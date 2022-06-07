import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/firebase_helper.dart';
import 'package:familytrusts/src/infrastructure/core/firestore_helpers.dart';
import 'package:familytrusts/src/infrastructure/core/storage_reference_helpers.dart';
import 'package:familytrusts/src/infrastructure/family/location_entity.dart';
import 'package:familytrusts/src/infrastructure/family/trusted_user_entity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;
import 'package:rxdart/rxdart.dart';

import 'child_entity.dart';

@LazySingleton(as: IFamilyRepository)
class FirebaseFamilyRepository implements IFamilyRepository {
  final FirebaseFirestore _firebaseFirestore;
  final firebase_storage.Reference _storageReference;
  final IUserRepository _userRepository;
  final Geoflutterfire _geoflutterfire;

  final IErrorService _errorService;

  FirebaseFamilyRepository(
    this._userRepository,
    this._firebaseFirestore,
    this._storageReference,
    this._geoflutterfire,
    this._errorService,
  );

  @override
  Stream<Either<ChildrenFailure, List<Either<ChildrenFailure, Child>>>>
      getChildren(String familyId) {
    return _firebaseFirestore
        .familyById(familyId)
        .childrenCollection
        .orderBy(fieldSurname)
        .snapshots()
        .map((snapshot) {
      return right<ChildrenFailure, List<Either<ChildrenFailure, Child>>>(
          snapshot.docs.map((doc) {
        try {
          final domain = ChildEntity.fromFirestore(doc).toDomain();
          return right<ChildrenFailure, Child>(domain);
        } catch (e) {
          _errorService.logException(e);
          return left<ChildrenFailure, Child>(
              const ChildrenFailure.unexpected());
        }
      }).toList());
    }).onErrorReturnWith(
      (e, stacktrace) {
        _errorService.logException(e);
        if (e is PlatformException &&
            (e.message?.contains('PERMISSION_DENIED') ?? false)) {
          return left(const ChildrenFailure.insufficientPermission());
        } else {
          return left(const ChildrenFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<ChildrenFailure, Child>> getChildById(
      {required String familyId, required String childId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore
              .familyById(familyId)
              .childrenCollection
              .doc(childId)
              .get();

      final domain = ChildEntity.fromFirestore(snapshot).toDomain();
      return right<ChildrenFailure, Child>(domain);
    } catch (_) {
      return left(const ChildrenFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, List<TrustedUser>>> getFutureTrustedUsers(
      String familyId) async {
    try {
      final snapshot = await _firebaseFirestore
          .familyById(familyId)
          .trustedCollection
          .orderBy(fieldSince)
          .get();

      final result = snapshot.docs.map((doc) async {
        final entity = TrustedUserEntity.fromFirestore(doc);
        final domain = await trustedUserEntityToTrustedUser(entity);
        return domain.fold(
          (failure) => left<UserFailure, TrustedUser>(failure),
          (trustedUser) => right<UserFailure, TrustedUser>(trustedUser),
        );
      }).toList();

      final resultWithout = (await Future.wait(result))
          .where((e) => e.isRight())
          .map((e) => e.toOption().toNullable()!)
          .toList();

      return right<UserFailure, List<TrustedUser>>(resultWithout);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    } on Exception {
      return left(const UserFailure.unableToUpdate());
    }
  }

  @override
  Stream<Either<UserFailure, List<TrustedUser>>> getTrustedUsers(
      String familyId) {
    final future = _firebaseFirestore
        .familyById(familyId)
        .trustedCollection
        .orderBy(fieldSince)
        .snapshots()
        .map(
      (snapshot) async {
        final result = snapshot.docs.map((doc) async {
          final entity = TrustedUserEntity.fromFirestore(doc);
          final domain = await trustedUserEntityToTrustedUser(entity);
          return domain.fold(
            (failure) => left<UserFailure, TrustedUser>(failure),
            (trustedUser) => right<UserFailure, TrustedUser>(trustedUser),
          );
        }).toList();
        final resultWithout = (await Future.wait(result))
            .where((e) => e.isRight())
            .map((e) => e.toOption().toNullable()!)
            .toList();
        return right<UserFailure, List<TrustedUser>>(resultWithout);
      },
    ).onErrorReturnWith(
      (e, stacktrace) async {
        _errorService.logException(e);
        if (e is PlatformException &&
            (e.message?.contains('PERMISSION_DENIED') ?? false)) {
          return left(const UserFailure.insufficientPermission());
        } else {
          return left(const UserFailure.unexpected());
        }
      },
    );
    return transformStream(future);
  }

  Stream<Either<UserFailure, List<TrustedUser>>> transformStream(
      Stream<Future<Either<UserFailure, List<TrustedUser>>>> values) async* {
    await for (final domains in values) {
      yield await domains;
    }
  }

  Future<Either<UserFailure, TrustedUser>> trustedUserEntityToTrustedUser(
      TrustedUserEntity trustedUserEntity) async {
    final Either<UserFailure, User> eitherTrustedUser =
        await _userRepository.getUser(trustedUserEntity.id);

    return eitherTrustedUser.fold(
      (userFailure) => left(userFailure),
      (user) => right(
        TrustedUser(
          user: user,
          since: TimestampVo.fromTimestamp(trustedUserEntity.since),
        ),
      ),
    );
  }

  @override
  Future<Either<UserFailure, Unit>> addTrustedUser(
      {required String familyId, required TrustedUser trustedUser}) async {
    try {
      final TrustedUserEntity trustedUserEntity = trustedUser.toEntity();

      await _firebaseFirestore
          .familyById(familyId)
          .trustedCollection
          .doc(trustedUserEntity.id)
          .set(trustedUserEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    } on Exception {
      return left(const UserFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> deleteTrustedUser(
      {required String familyId, required String trustedUserId}) async {
    try {
      await _firebaseFirestore
          .familyById(familyId)
          .trustedCollection
          .doc(trustedUserId)
          .delete();
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    } on Exception {
      return left(const UserFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<ChildrenFailure, Unit>> deleteChild({
    required String familyId,
    required Child child,
  }) async {
    try {
      if (child.photoUrl != null) {
        FirebaseHelper.deleteImageByUrl(child.photoUrl!);
      }
      await _firebaseFirestore
          .familyById(familyId)
          .childrenCollection
          .doc(child.id)
          .delete();
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const ChildrenFailure.insufficientPermission());
      } else {
        return left(const ChildrenFailure.unexpected());
      }
    } on Exception {
      return left(const ChildrenFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<ChildrenFailure, Unit>> addUpdateChild({
    required String familyId,
    required Child child,
    String? pickedFilePath,
  }) async {
    try {
      Child updatedChild = child;
      if (quiver.isBlank(child.id)) {
        updatedChild = child.copyWith(
            id: _firebaseFirestore
                .familyById(familyId)
                .childrenCollection
                .doc()
                .id);
      }

      if (quiver.isNotBlank(pickedFilePath)) {
        final firebase_storage.Reference ref =
            _storageReference.childrenPhotoStorage(updatedChild.id!);

        final String downloadUrl =
            await FirebaseHelper.addImage(File(pickedFilePath!), ref);

        updatedChild = child.copyWith(photoUrl: downloadUrl);
      }
      _firebaseFirestore
          .familyById(familyId)
          .childrenCollection
          .doc(updatedChild.id)
          .set(ChildEntity.fromDomain(updatedChild).toJson());

      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const ChildrenFailure.insufficientPermission());
      } else {
        return left(const ChildrenFailure.unexpected());
      }
    } on Exception {
      return left(const ChildrenFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> addUpdateLocation({
    required String familyId,
    required Location location,
    String? pickedFilePath,
  }) async {
    try {
      Location updatedLocation = location;
      if (quiver.isBlank(location.id)) {
        updatedLocation = location.copyWith(
          id: _firebaseFirestore
              .familyById(familyId)
              .locationsCollection
              .doc()
              .id,
        );
      }

      if (quiver.isNotBlank(pickedFilePath)) {
        final firebase_storage.Reference ref = _storageReference
            .locationPhotoStorage(familyId, updatedLocation.id!);

        final String downloadUrl =
            await FirebaseHelper.addImage(File(pickedFilePath!), ref);

        updatedLocation = location.copyWith(photoUrl: downloadUrl);
      }

      final locationEntity = LocationEntity.fromDomain(updatedLocation);
      final data = locationEntity.toJson();

      if (locationEntity.position != null) {
        final GeoFirePoint point = _geoflutterfire.point(
          latitude: locationEntity.position!.latitude,
          longitude: locationEntity.position!.longitude,
        );

        data.addAll({"position": point.data});
      }

      _firebaseFirestore
          .familyById(familyId)
          .locationsCollection
          .doc(updatedLocation.id)
          .set(data);
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const LocationFailure.insufficientPermission());
      } else {
        return left(const LocationFailure.unexpected());
      }
    } on Exception {
      return left(const LocationFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> deleteLocation({
    required String familyId,
    required Location location,
  }) async {
    try {
      if (quiver.isNotBlank(location.photoUrl)) {
        await FirebaseHelper.deleteImageByUrl(location.photoUrl!);
      }
      _firebaseFirestore
          .familyById(familyId)
          .locationsCollection
          .doc(location.id)
          .delete();
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const LocationFailure.insufficientPermission());
      } else {
        return left(const LocationFailure.unexpected());
      }
    } on Exception {
      return left(const LocationFailure.unableToDelete());
    }
  }

  @override
  Stream<Either<LocationFailure, List<Either<LocationFailure, Location>>>>
      getLocations(String familyId) {
    return _firebaseFirestore
        .familyById(familyId)
        .locationsCollection
        .snapshots()
        .map(
      (snapshot) {
        return right<LocationFailure, List<Either<LocationFailure, Location>>>(
          snapshot.docs.map((doc) {
            try {
              final locationEntity = LocationEntity.fromFirestore(doc).copyWith(
                  position: doc.data()["position"]["geopoint"] as GeoPoint);
              final domain = locationEntity.toDomain();
              return right<LocationFailure, Location>(domain);
            } catch (_) {
              return left<LocationFailure, Location>(
                  const LocationFailure.unexpected());
            }
          }).toList(),
        );
      },
    ).onErrorReturnWith(
      (e, stacktrace) {
        _errorService.logException(e);
        if (e is PlatformException &&
            (e.message?.contains('PERMISSION_DENIED') ?? false)) {
          return left(const LocationFailure.insufficientPermission());
        } else {
          return left(const LocationFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<LocationFailure, Location>> getLocationById(
      {required String familyId, required String locationId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore
              .familyById(familyId)
              .locationsCollection
              .doc(locationId)
              .get();

      final locationEntity = LocationEntity.fromFirestore(snapshot).copyWith(
          position: snapshot.data()!["position"]["geopoint"] as GeoPoint);
      final domain = locationEntity.toDomain();
      return right<LocationFailure, Location>(domain);
    } catch (_) {
      return left(const LocationFailure.unexpected());
    }
  }
}
