import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';

abstract class IFamilyEventRepository {
  Future<Either<EventFailure, List<Event>>> getEvents(String userId);

  Future<Either<NotificationsFailure, int>> getUnReadCount(String userId);

  Future<Either<NotificationsFailure, Unit>> deleteEvent(
    String userId,
    Event event,
  );

  Future<Either<NotificationsFailure, Unit>> markAsReadEvent(
    String userId,
    Event event,
  );
}
