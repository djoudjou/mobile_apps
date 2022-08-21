import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/core/firestore_helpers.dart';
import 'package:familytrusts/src/infrastructure/notification/event_entity.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INotificationRepository)
class FirebaseNotificationRepository
    with LogMixin
    implements INotificationRepository {
  final FirebaseFirestore _firebaseFirestore;
  final IUserRepository _userRepository;
  final IChildrenLookupRepository _childrenLookupRepository;
  final IErrorService _errorService;

  FirebaseNotificationRepository(
    this._userRepository,
    this._firebaseFirestore,
    this._childrenLookupRepository,
    this._errorService,
  );

  @override
  Future<Either<NotificationsFailure, Unit>> createEvent(
    String userId,
    Event event,
  ) async {
    try {
      final EventEntity eventEntity = EventEntity.fromDomain(event);
      await _firebaseFirestore
          .notificationsByUserId(userId)
          .eventsCollection
          .doc()
          .set(eventEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NotificationsFailure.insufficientPermission());
      } else {
        return left(const NotificationsFailure.unexpected());
      }
    } on Exception {
      return left(const NotificationsFailure.unexpected());
    }
  }

  @override
  Future<Either<NotificationsFailure, Unit>> deleteEvent(
    String userId,
    Event event,
  ) async {
    try {
      await _firebaseFirestore
          .notificationsByUserId(userId)
          .eventsCollection
          .doc(event.id)
          .delete();
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NotificationsFailure.insufficientPermission());
      } else {
        return left(const NotificationsFailure.unexpected());
      }
    } on Exception {
      return left(const NotificationsFailure.unexpected());
    }
  }

  @override
  Future<Either<NotificationsFailure, Unit>> updateEvent(
    String userId,
    Event event,
  ) async {
    try {
      final EventEntity eventEntity = EventEntity.fromDomain(event);
      await _firebaseFirestore
          .notificationsByUserId(userId)
          .eventsCollection
          .doc(event.id)
          .update(eventEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NotificationsFailure.insufficientPermission());
      } else {
        return left(const NotificationsFailure.unexpected());
      }
    } on Exception {
      return left(const NotificationsFailure.unexpected());
    }
  }


  @override
  Stream<List<Either<EventFailure, Event>>> getEvents(String userId) {
    /// on se limite à 14 jours de notifications
    final notificationLimit = DateTime.now()
        .add(
          const Duration(days: -14),
        )
        .millisecondsSinceEpoch;
    return transformEvents(
      userId,
      _firebaseFirestore
          .notificationsByUserId(userId)
          .eventsCollection
          .where(fieldDate, isGreaterThan: notificationLimit)
          .orderBy(fieldDate, descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => EventEntity.fromFirestore(doc))
                .toList(),
          )
          .handleError(
            (err, stacktrace) => log('_getEvents handleError: $err'),
          ),
    );
  }

  Stream<List<Either<EventFailure, Event>>> transformEvents(
    String connectedUserId,
    Stream<List<EventEntity>> eventEntities,
  ) async* {
    await for (final entities in eventEntities) {
      final List<Future<Either<EventFailure, Event>>> futures = entities
          .map(
            (eventEntity) => eventEntityToEvent(connectedUserId, eventEntity),
          )
          .toList();

      yield await Future.wait(futures);
    }
  }

  Future<Either<EventFailure, Event>> eventEntityToEvent(
    String connectedUserId,
    EventEntity eventEntity,
  ) async {
    final Either<UserFailure, User> eitherFromUser =
        await _userRepository.getUser(eventEntity.from);
    final Either<UserFailure, User> eitherToUser =
        await _userRepository.getUser(eventEntity.to);

    return eitherFromUser.fold(
      (userFromFailure) =>
          left(EventFailure.unableToLoadUserFrom(eventEntity.from)),
      (fromUser) => eitherToUser.fold(
        (userToFailure) =>
            left(EventFailure.unableToLoadUserTo(eventEntity.to)),
        (toUser) => right(
          Event(
            id: eventEntity.id,
            type: EventType.fromValue(eventEntity.type),
            date: TimestampVo.fromTimestamp(eventEntity.date),
            from: fromUser,
            to: toUser,
            seen: eventEntity.seen,
            subject: eventEntity.subject!,
            fromConnectedUser: fromUser.id == connectedUserId,
          ),
        ),
      ),
    );
  }

  @override
  Future<Either<NotificationsFailure, Unit>> createEventForChildrenLookup(
    ChildrenLookup childrenLookup,
    Event event,
  ) async {
    try {
      final users = [
        ...childrenLookup.trustedUsers,
        childrenLookup.issuer?.id,
        childrenLookup.issuer?.spouse
      ];

      final distinctIds =
          users.where((elt) => quiver.isNotBlank(elt)).toSet().toList();

      for (final userId in distinctIds) {
        await createEvent(userId!, event);
      }

      return right(unit);
    } on PlatformException catch (e) {
      _errorService.logException(e);
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const NotificationsFailure.insufficientPermission());
      } else {
        return left(const NotificationsFailure.unexpected());
      }
    } on Exception {
      return left(const NotificationsFailure.unexpected());
    }
  }

  @override
  Stream<Either<NotificationsFailure, int>> getUnReadCount(
    String userId,
  ) async* {
    final doc = _firebaseFirestore.notificationsByUserId(userId);

    yield* doc.snapshots().map(
      (snapshot) {
        if (!snapshot.exists) {
          return left<NotificationsFailure, int>(
            const NotificationsFailure.unexpected(),
          );
        }

        return right<NotificationsFailure, int>(
          snapshot.data()?['unReadCount'] as int,
        );
      },
    ).onErrorReturnWith(
      (e, stacktrace) {
        if (e is PlatformException &&
            (e.message?.contains('PERMISSION_DENIED') ?? false)) {
          return left(const NotificationsFailure.insufficientPermission());
        } else {
          // log.error(e.toString());
          //log("WTF $e");
          return left(const NotificationsFailure.unexpected());
        }
      },
    );
  }
}
