import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_events_update_event.freezed.dart';

@freezed
class NotificationsEventsUpdateEvent with _$NotificationsEventsUpdateEvent {
  const factory NotificationsEventsUpdateEvent.markAsRead(
    User currentUser,
    Event notification,
  ) = MarkAsRead;

  const factory NotificationsEventsUpdateEvent.deleteEvent(
    User currentUser,
    Event notification,
  ) = DeleteEvent;
}
