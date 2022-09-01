import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/event_failure.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_mark_as_read_dto.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_remove_dto.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_events_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IFamilyEventRepository)
class ApiFamilyEventRepository with LogMixin implements IFamilyEventRepository {
  final ApiService _apiService;

  ApiFamilyEventRepository(this._apiService);

  @override
  Future<Either<NotificationsFailure, Unit>> deleteEvent(
    String userId,
    Event event,
  ) async {
    try {
      await _apiService.getFamilyEventRestClient().remove(
            event.id!,
            FamilyEventRemoveDTO(issuerId: userId),
          );
      return right(unit);
    } catch (e) {
      log("error in deleteEvent method : $e");
      return left(const NotificationsFailure.unexpected());
    }
  }

  @override
  Future<Either<EventFailure, List<Event>>> getEvents(String userId) async {
    try {
      final FamilyEventsDTO familyEvents = await _apiService
          .getFamilyEventRestClient()
          .findEventsByMemberId(userId);

      if (familyEvents.events != null) {
        return right(familyEvents.events!.map((f) => f.toDomain()).toList());
      } else {
        return right([]);
      }
    } catch (e) {
      log("error in getEvents method : $e");
      return left(const EventFailure.unexpected());
    }
  }

  @override
  Future<Either<NotificationsFailure, int>> getUnReadCount(
    String userId,
  ) async {
    try {
      final FamilyEventsDTO familyEvents = await _apiService
          .getFamilyEventRestClient()
          .findEventsByMemberId(userId);

      return right(familyEvents.nbNotSeen!);
    } catch (e) {
      log("error in getUnReadCount method : $e");
      return left(const NotificationsFailure.unexpected());
    }
  }

  @override
  Future<Either<NotificationsFailure, Unit>> markAsReadEvent(
    String userId,
    Event event,
  ) async {
    try {
      await _apiService.getFamilyEventRestClient().markAsRead(
            event.id!,
            FamilyEventMarkAsReadDTO(issuerId: userId),
          );
      return right(unit);
    } catch (e) {
      log("error in markAsReadEvent method : $e");
      return left(const NotificationsFailure.unexpected());
    }
  }
}
