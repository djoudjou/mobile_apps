import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_tab_event.freezed.dart';

@freezed
abstract class NotificationTabEvent with _$NotificationTabEvent {
  const factory NotificationTabEvent.init(NotificationTab currentTab) = Init;

  const factory NotificationTabEvent.gotoDemands() = GotoDemands;

  const factory NotificationTabEvent.gotoInvitations() = GotoInvitations;

  const factory NotificationTabEvent.gotoNotifications() = GotoNotifications;
}
