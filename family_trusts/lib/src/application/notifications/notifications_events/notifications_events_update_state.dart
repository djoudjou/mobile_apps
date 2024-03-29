import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_events_update_state.freezed.dart';

@freezed
class NotificationsEventsUpdateState with _$NotificationsEventsUpdateState {
  const factory NotificationsEventsUpdateState({
    required bool markAsReadInProgress,
    required bool isDeleting,
    required Option<Either<NotificationsFailure, Unit>>
        markAsReadFailureOrSuccessOption,
    required Option<Either<NotificationsFailure, Unit>>
        deleteFailureOrSuccessOption,
  }) = _NotificationsEventsUpdateState;

  factory NotificationsEventsUpdateState.initial() =>
      NotificationsEventsUpdateState(
        markAsReadInProgress: false,
        isDeleting: false,
        markAsReadFailureOrSuccessOption: none(),
        deleteFailureOrSuccessOption: none(),
      );
}
