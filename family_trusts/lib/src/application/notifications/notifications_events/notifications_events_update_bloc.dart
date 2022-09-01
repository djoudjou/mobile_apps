import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_update_event.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_update_state.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsEventsUpdateBloc extends Bloc<NotificationsEventsUpdateEvent,
    NotificationsEventsUpdateState> {
  final IFamilyEventRepository _notificationRepository;

  NotificationsEventsUpdateBloc(this._notificationRepository)
      : super(NotificationsEventsUpdateState.initial()) {
    on<MarkAsRead>(_mapMarkAsReadToState, transformer: sequential());
    on<DeleteEvent>(_mapDeleteNotificationToState, transformer: sequential());
  }

  FutureOr<void> _mapMarkAsReadToState(
    MarkAsRead event,
    Emitter<NotificationsEventsUpdateState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          markAsReadInProgress: true,
          markAsReadFailureOrSuccessOption: none(),
        ),
      );
      final Either<NotificationsFailure, Unit> result =
          await _notificationRepository.markAsReadEvent(
        event.currentUser.id!,
        event.notification,
      );
      emit(
        result.fold(
          (l) => state.copyWith(
            markAsReadInProgress: false,
            markAsReadFailureOrSuccessOption: some(left(l)),
          ),
          (r) => state.copyWith(
            markAsReadInProgress: false,
            markAsReadFailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    } catch (execption) {
      emit(
        state.copyWith(
          markAsReadInProgress: false,
          markAsReadFailureOrSuccessOption:
              some(left(const NotificationsFailure.unexpected())),
        ),
      );
    }
  }

  FutureOr<void> _mapDeleteNotificationToState(
    DeleteEvent event,
    Emitter<NotificationsEventsUpdateState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isDeleting: true,
          deleteFailureOrSuccessOption: none(),
        ),
      );
      final Either<NotificationsFailure, Unit> result =
          await _notificationRepository.deleteEvent(
        event.currentUser.id!,
        event.notification,
      );

      emit(
        result.fold(
          (l) => state.copyWith(
            isDeleting: false,
            deleteFailureOrSuccessOption: some(left(l)),
          ),
          (r) => state.copyWith(
            isDeleting: false,
            deleteFailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    } catch (execption) {
      emit(
        state.copyWith(
          isDeleting: false,
          deleteFailureOrSuccessOption:
              some(left(const NotificationsFailure.unexpected())),
        ),
      );
    }
  }
}
