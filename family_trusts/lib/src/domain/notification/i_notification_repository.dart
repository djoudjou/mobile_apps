import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';

abstract class INotificationRepository {
  //Stream<Either<NotificationsFailure,Notifications>> getNotifications(String userId);
  Stream<List<Either<EventFailure, Event>>> getEvents(String userId);

  Stream<Either<NotificationsFailure, int>> getUnReadCount(String userId);

  Future<Either<NotificationsFailure, Unit>> createEvent(
    String userId,
    Event event,
  );

  Future<Either<NotificationsFailure, Unit>> updateEvent(
    String userId,
    Event event,
  );

  Future<Either<NotificationsFailure, Unit>> deleteEvent(
    String userId,
    Event event,
  );

  Future<Either<NotificationsFailure, Unit>> createEventForChildrenLookup(
    ChildrenLookup childrenLookup,
    Event event,
  );
}
