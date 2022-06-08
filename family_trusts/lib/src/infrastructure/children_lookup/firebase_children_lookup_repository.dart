import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_entry.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/children_lookup/children_lookup_entity.dart';
import 'package:familytrusts/src/infrastructure/children_lookup/children_lookup_history_entity.dart';
import 'package:familytrusts/src/infrastructure/core/firestore_helpers.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IChildrenLookupRepository)
class FirebaseChildrenLookupRepository
    with LogMixin
    implements IChildrenLookupRepository {
  final FirebaseFirestore _firebaseFirestore;
  final IUserRepository _userRepository;
  final IFamilyRepository _familyRepository;
  final IErrorService _errorService;

  FirebaseChildrenLookupRepository(
    this._userRepository,
    this._firebaseFirestore,
    this._errorService,
    this._familyRepository,
  );

  @override
  Future<Either<ChildrenLookupFailure, Unit>> addChildrenLookupHistory({
    required String childrenLookupId,
    required ChildrenLookupHistory childrenLookupHistory,
  }) async {
    try {
      final ChildrenLookupHistoryEntity childrenLookupHistoryEntity =
          ChildrenLookupHistoryEntity.fromDomain(childrenLookupHistory);

      await _firebaseFirestore
          .childrenLookupHistory(
            childrenLookupId: childrenLookupId,
            childrenLookupHistoryId: childrenLookupHistoryEntity.id,
          )
          .set(childrenLookupHistoryEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const ChildrenLookupFailure.insufficientPermission());
      } else {
        return left(const ChildrenLookupFailure.serverError());
      }
    } on Exception {
      return left(const ChildrenLookupFailure.unableToUpdate());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, Unit>> addUpdateChildrenLookup({
    required ChildrenLookup childrenLookup,
  }) async {
    try {
      final ChildrenLookupEntity childrenLookupEntity =
          ChildrenLookupEntity.fromDomain(childrenLookup);

      await _firebaseFirestore
          .childrenLookup(childrenLookupId: childrenLookupEntity.id!)
          .set(childrenLookupEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const ChildrenLookupFailure.insufficientPermission());
      } else {
        return left(const ChildrenLookupFailure.serverError());
      }
    } on Exception {
      return left(const ChildrenLookupFailure.unableToUpdate());
    }
  }

  @override
  Stream<List<Either<ChildrenLookupFailure, ChildrenLookup>>>
      getChildrenLookupsByFamilyId({required String familyId}) {
    return transformChildrenLookup(
      _firebaseFirestore
          .childrenLookups()
          .where("familyId", isEqualTo: familyId)
          .orderBy("rendezVous")
          .snapshots()
          .map(
        (snapshot) {
          return snapshot.docs
              .map((doc) => ChildrenLookupEntity.fromFirestore(doc))
              .toList();
        },
      ).handleError(
        (err, stacktrace) =>
            log('_getChildrenLookupsByFamilyId handleError: $err'),
      ),
    );
  }

  @override
  Stream<List<Either<ChildrenLookupFailure, ChildrenLookup>>>
      getChildrenLookupsByTrustedId({required String trustedUserId}) {
    return transformChildrenLookup(
      _firebaseFirestore
          .childrenLookups()
          .where("trustedUsers", arrayContains: trustedUserId)
          .orderBy("rendezVous", descending: true)
          .snapshots()
          .map(
        (snapshot) {
          return snapshot.docs
              .map((doc) => ChildrenLookupEntity.fromFirestore(doc))
              .toList();
        },
      ).handleError(
        (err, stacktrace) =>
            log('_getChidrenLookupsByTrustedId handleError: $err'),
      ),
    );
  }

  Stream<List<Either<ChildrenLookupFailure, ChildrenLookup>>>
      transformChildrenLookup(
    Stream<List<ChildrenLookupEntity>> childrenLookupEntities,
  ) async* {
    await for (final entities in childrenLookupEntities) {
      final List<Future<Either<ChildrenLookupFailure, ChildrenLookup>>>
          futures = entities
              .map((entity) => childrenLookupEntityToChildrenLookup(entity))
              .toList();

      yield await Future.wait(futures);
    }
  }

  Future<Either<ChildrenLookupFailure, ChildrenLookup>>
      childrenLookupEntityToChildrenLookup(
    ChildrenLookupEntity? childrenLookupEntity,
  ) async {
    if (childrenLookupEntity == null) {
      return left(const ChildrenLookupFailure.serverError());
    } else {
      User? personInCharge;
      if (childrenLookupEntity.personInChargeId == null) {
        personInCharge = null;
      } else {
        final Either<UserFailure, User> eitherPersonInCharge =
            await _userRepository
                .getUser(childrenLookupEntity.personInChargeId!);

        if (eitherPersonInCharge.isLeft()) {
          return left(
            ChildrenLookupFailure.invalidPersonInCharge(
              childrenLookupEntity.personInChargeId,
            ),
          );
        }

        personInCharge = eitherPersonInCharge.toOption().toNullable();
      }

      User? issuer;

      if (childrenLookupEntity.issuerId == null) {
        issuer = null;
      } else {
        final Either<UserFailure, User> eitherIssuer =
            await _userRepository.getUser(childrenLookupEntity.issuerId!);

        if (eitherIssuer.isLeft()) {
          return left(
            ChildrenLookupFailure.invalidIssuer(
              childrenLookupEntity.issuerId,
            ),
          );
        }

        issuer = eitherIssuer.toOption().toNullable();
      }

      Location? location;
      if (childrenLookupEntity.locationId == null ||
          childrenLookupEntity.familyId == null) {
        location = null;
      } else {
        final Either<LocationFailure, Location> eitherLocation =
            await _familyRepository.getLocationById(
          familyId: childrenLookupEntity.familyId!,
          locationId: childrenLookupEntity.locationId!,
        );

        if (eitherLocation.isLeft()) {
          return left(
            ChildrenLookupFailure.invalidLocation(
              childrenLookupEntity.locationId,
            ),
          );
        }
        location = eitherLocation.toOption().toNullable();
      }

      Child? child;
      if (childrenLookupEntity.childId == null) {
        child = null;
      } else {
        final Either<ChildrenFailure, Child> eitherChild =
            await _familyRepository.getChildById(
          familyId: childrenLookupEntity.familyId!,
          childId: childrenLookupEntity.childId!,
        );
        if (eitherChild.isLeft()) {
          return left(
            ChildrenLookupFailure.invalidChild(childrenLookupEntity.childId),
          );
        }
        child = eitherChild.toOption().toNullable();
      }

      return right(
        ChildrenLookup(
          id: childrenLookupEntity.id,
          state: MissionState.fromValue(childrenLookupEntity.state),
          creationDate:
              TimestampVo.fromTimestamp(childrenLookupEntity.creationDate),
          child: child,
          location: location,
          issuer: issuer,
          rendezVous: RendezVous.fromDate(childrenLookupEntity.rendezVous),
          noteBody: NoteBody(childrenLookupEntity.notes),
          trustedUsers: childrenLookupEntity.trustedUsers,
          personInCharge: personInCharge,
        ),
      );
    }
  }

  @override
  Stream<List<Either<ChildrenLookupFailure, ChildrenLookupHistory>>>
      getChildrenLookupHistories({
    required String childrenLookupId,
  }) {
    return transformChildrenLookupHistories(
      _firebaseFirestore
          .childrenLookupHistories(childrenLookupId: childrenLookupId)
          .orderBy("creationDate")
          .snapshots()
          .map(
        (snapshot) {
          return snapshot.docs
              .map((doc) => ChildrenLookupHistoryEntity.fromFirestore(doc))
              .toList();
        },
      ).handleError(
        (err, stacktrace) =>
            log('_getChildrenLookupHistories handleError: $err'),
      ),
    );
  }

  Stream<List<Either<ChildrenLookupFailure, ChildrenLookupHistory>>>
      transformChildrenLookupHistories(
    Stream<List<ChildrenLookupHistoryEntity>> childrenLookupHistoryEntities,
  ) async* {
    await for (final entities in childrenLookupHistoryEntities) {
      final List<Future<Either<ChildrenLookupFailure, ChildrenLookupHistory>>>
          futures = entities
              .map(
                (entity) =>
                    childrenLookupHistoryEntityToChildrenLookupHistory(entity),
              )
              .toList();

      yield await Future.wait(futures);
    }
  }

  Future<Either<ChildrenLookupFailure, ChildrenLookupHistory>>
      childrenLookupHistoryEntityToChildrenLookupHistory(
    ChildrenLookupHistoryEntity childrenLookupHistoryEntity,
  ) async {
    final Either<UserFailure, User> eitherSubject =
        await _userRepository.getUser(childrenLookupHistoryEntity.subjectId);

    return eitherSubject.fold(
      (userFailure) => left(
        ChildrenLookupFailure.invalidIssuer(
          childrenLookupHistoryEntity.subjectId,
        ),
      ),
      (subject) => right(
        ChildrenLookupHistory(
          id: childrenLookupHistoryEntity.id,
          message: childrenLookupHistoryEntity.message,
          eventType:
              MissionEventType.fromValue(childrenLookupHistoryEntity.type),
          creationDate: TimestampVo.fromTimestamp(
            childrenLookupHistoryEntity.creationDate,
          ),
          subject: subject,
        ),
      ),
    );
  }

  @override
  Stream<Either<ChildrenLookupFailure, ChildrenLookup>> watchChildrenLookup({
    required String childrenLookupId,
  }) async* {
    final childrenlookupDoc =
        _firebaseFirestore.childrenLookup(childrenLookupId: childrenLookupId);

    try {
      final Stream<Either<ChildrenLookupFailure, ChildrenLookupEntity>> result =
          childrenlookupDoc.snapshots().map(
        (snapshot) {
          if (!snapshot.exists) {
            return left(ChildrenLookupFailure.unknowned(childrenLookupId));
          }
          return right(ChildrenLookupEntity.fromFirestore(snapshot));
        },
      );

      yield* transformChild(result);
    } catch (e) {
      log('watchChildrenLookup handleError: $e');
    }
  }

  Stream<Either<ChildrenLookupFailure, ChildrenLookup>> transformChild(
    Stream<Either<ChildrenLookupFailure, ChildrenLookupEntity>>
        childrenLookupEntity,
  ) async* {
    await for (final entity in childrenLookupEntity) {
      final Future<Either<ChildrenLookupFailure, ChildrenLookup>> futures =
          childrenLookupEntityToChildrenLookup(entity.toOption().toNullable());

      yield await futures;
    }
  }

  @override
  Stream<Either<PlanningFailure, Planning>> getPlanning({
    required String userId,
  }) {
    return transformChildrenLookup(
      _firebaseFirestore
          .childrenLookups()
          .where("trustedUsers", arrayContains: userId)
          .where(
            "rendezVous",
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ),
            ),
          )
          .snapshots()
          .map(
        (snapshot) {
          return snapshot.docs
              .map((doc) => ChildrenLookupEntity.fromFirestore(doc))
              .toList();
        },
      ).handleError((err, stacktrace) => log('getPlanning handleError: $err')),
    )
        .map(
      (
        List<Either<ChildrenLookupFailure, ChildrenLookup>>
            eitherChildrenLookups,
      ) =>
          eitherChildrenLookups
              .where((element) => element.isRight())
              .map((e) => e.toOption().toNullable()!)
              .toList(),
    )
        .map((childrenLookups) {
      try {
        final List<PlanningEntry> entries = List<PlanningEntry>.generate(
          31,
          (index) {
            final date = DateTime.utc(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ).add(Duration(days: index));

            final dateAfter = date.add(const Duration(days: 1));

            final filteredChildrenLookup = childrenLookups.where((element) {
              final rdv = element.rendezVous.getOrCrash();
              return rdv.isAfter(date) && rdv.isBefore(dateAfter);
            }).toList();

            return PlanningEntry(
              day: date,
              childrenLookups: filteredChildrenLookup,
            );
          },
        );
        return right(Planning(entries: entries));
      } catch (e) {
        _errorService.logException(e);
        return left(const PlanningFailure.serverError());
      }
    });
  }
}
