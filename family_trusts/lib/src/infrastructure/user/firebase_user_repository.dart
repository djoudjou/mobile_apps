import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:diacritic/diacritic.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/firebase_helper.dart';
import 'package:familytrusts/src/infrastructure/core/firestore_helpers.dart';
import 'package:familytrusts/src/infrastructure/core/storage_reference_helpers.dart';
import 'package:familytrusts/src/infrastructure/user/user_entity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;
import 'package:rxdart/rxdart.dart';

@Environment(Environment.dev)
@LazySingleton(as: IUserRepository)
class FirebaseUserRepository implements IUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final firebase_storage.Reference _storageReference;
  final AnalyticsSvc _analyticsSvc;

  FirebaseUserRepository(
    this._firebaseFirestore,
    this._storageReference,
    this._analyticsSvc,
  );

  Future<void> _upsetUser(UserEntity userEntity) async {
    await _firebaseFirestore
        .userDocumentByUserId(userEntity.id!)
        .update(userEntity.toJson());
  }

  @override
  Future<Either<UserFailure, User>> getUser(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.userDocumentByUserId(userId).get();

      if (!snapshot.exists) {
        _analyticsSvc.missingUser(userId);
        _analyticsSvc.debug("unknown user $userId");
        return left(UserFailure.unknownUser(userId));
      } else {
        final userEntity = UserEntity.fromFirestore(snapshot);

        /// to update keywords TODO to remove soon or later
        _updateUserKeywords(userEntity);
        return right(userEntity.toDomain());
      }
    } on PlatformException catch (e) {
      _analyticsSvc.debug("getUser Error $userId");
      _analyticsSvc.missingUser(userId);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<UserFailure, Unit>> update(
    User updatedUser, {
    String? pickedFilePath,
  }) async {
    try {
      User userToUpdate = updatedUser;

      if (quiver.isNotBlank(pickedFilePath)) {
        final firebase_storage.Reference ref =
            _storageReference.userPhotoStorage(updatedUser.id!);

        final String downloadUrl =
            await FirebaseHelper.addImage(File(pickedFilePath!), ref);

        userToUpdate = updatedUser.copyWith(photoUrl: downloadUrl);
      }

      final userEntity = UserEntity.fromDomain(userToUpdate);
      _updateUserKeywords(userEntity);
      _upsetUser(userEntity);
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    } on Exception {
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> create(
    User user, {
    String? pickedFilePath,
  }) async {
    try {
      UserEntity userEntity = UserEntity.fromDomain(user);

      if (quiver.isNotBlank(pickedFilePath)) {
        final firebase_storage.Reference ref =
            _storageReference.userPhotoStorage(userEntity.id!);

        final String downloadUrl =
            await FirebaseHelper.addImage(File(pickedFilePath!), ref);

        userEntity = userEntity.copyWith(photoUrl: downloadUrl);
      }

      _firebaseFirestore
          .userDocumentByUserId(userEntity.id!)
          .set(userEntity.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const UserFailure.insufficientPermission());
      } else {
        return left(const UserFailure.unexpected());
      }
    } on Exception {
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Stream<Either<UserFailure, User>> watchUser(String userId) async* {
    final userDoc = _firebaseFirestore.userDocumentByUserId(userId);

    yield* userDoc.snapshots().map(
      (snapshot) {
        if (!snapshot.exists) {
          return left<UserFailure, User>(UserFailure.unknownUser(userId));
        }
        return right<UserFailure, User>(
          UserEntity.fromFirestore(snapshot).toDomain(),
        );
      },
    ).onErrorReturnWith(
      (e, stacktrace) {
        if (e is PlatformException &&
            (e.message?.contains('PERMISSION_DENIED') ?? false)) {
          return left(const UserFailure.insufficientPermission());
        } else {
          // log.error(e.toString());
          //log("WTF $e");
          return left(const UserFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<SearchUserFailure, Stream<List<User>>>> searchUsers(
    String userLookupText, {
    List<String>? excludedUsers,
  }) async {
    try {
      final Stream<List<User>> streamUsers = _firebaseFirestore
          .collection(FirebaseFirestoreX.usersCollectionName)
          .where(
            "keywords",
            arrayContains: removeDiacritics(userLookupText.toLowerCase()),
          )
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (snapshot) => UserEntity.fromFirestore(snapshot).toDomain(),
                )
                .where(
                  (element) =>
                      excludedUsers == null ||
                      !excludedUsers.contains(element.id),
                )
                .toList(),
          );
      return right(streamUsers);
    } on Exception {
      return left(const SearchUserFailure.serverError());
    }
  }

  Future<void> _updateUserKeywords(UserEntity userEntity) async {
    await _firebaseFirestore.userDocumentByUserId(userEntity.id!).update(
      {'keywords': generateKeywords(userEntity.surname, userEntity.name)},
    );
  }

  @override
  Future<Either<UserFailure, Unit>> saveToken(
    String userId,
    String token,
  ) async {
    try {
      await _firebaseFirestore
          .userDocumentByUserId(userId)
          .collection("tokens")
          .doc(token)
          .set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
      return right(unit);
    } on Exception {
      return left(const UserFailure.unexpected());
    }
  }
}

List<String> _createKeywords(String name) {
  final List<String> arrName = [];
  var curName = '';
  removeDiacritics(name.toLowerCase()).split('').forEach(
    (letter) {
      curName += letter;
      arrName.add(curName);
    },
  );
  return arrName;
}

List<String> generateKeywords(String surname, String name) {
  final Set<String> numberSet = HashSet<String>();
  numberSet.addAll(_createKeywords("$surname $name"));
  numberSet.addAll(_createKeywords("$name $surname"));
  numberSet.addAll(_createKeywords(surname));
  numberSet.addAll(_createKeywords(name));

  return numberSet.toList();
}
