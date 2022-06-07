import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_tab_state.freezed.dart';

@freezed
abstract class NotificationTabState with _$NotificationTabState {
  const factory NotificationTabState({
    required NotificationTab current,
  }) = _NotificationTabState;

  factory NotificationTabState.initial() => const NotificationTabState(
        current: NotificationTab.demands,
      );
}
