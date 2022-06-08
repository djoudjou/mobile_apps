import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_update_event.dart';
import 'package:familytrusts/src/application/notifications/notifications_events/notifications_events_update_state.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsEventsUpdateBloc extends Bloc<NotificationsEventsUpdateEvent,
    NotificationsEventsUpdateState> {
  final INotificationRepository _notificationRepository;

  NotificationsEventsUpdateBloc(this._notificationRepository)
      : super(NotificationsEventsUpdateState.initial()) {
    on<NotificationsEventsUpdateEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: sequential(),
    );
  }

  void mapEventToState(
    NotificationsEventsUpdateEvent event,
    Emitter<NotificationsEventsUpdateState> emit,
  ) {
    event.map(
      markAsRead: (event) {
        _mapMarkAsReadToState(event, emit);
      },
      deleteEvent: (DeleteEvent event) {
        _mapDeleteNotificationToState(event, emit);
      },
    );
  }

  FutureOr<void> _mapMarkAsReadToState(
    MarkAsRead event,
    Emitter<NotificationsEventsUpdateState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          markAsReadInProgress: true,
          markAsReadfailureOrSuccessOption: none(),
        ),
      );
      final Either<NotificationsFailure, Unit> result =
          await _notificationRepository.updateEvent(
        event.currentUser.id!,
        event.notification.copyWith(seen: true),
      );
      emit(
        result.fold(
          (l) => state.copyWith(
            markAsReadInProgress: false,
            markAsReadfailureOrSuccessOption: some(left(l)),
          ),
          (r) => state.copyWith(
            markAsReadInProgress: false,
            markAsReadfailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    } catch (execption) {
      emit(
        state.copyWith(
          markAsReadInProgress: false,
          markAsReadfailureOrSuccessOption:
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
          deletefailureOrSuccessOption: none(),
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
            deletefailureOrSuccessOption: some(left(l)),
          ),
          (r) => state.copyWith(
            isDeleting: false,
            deletefailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    } catch (execption) {
      emit(
        state.copyWith(
          isDeleting: false,
          deletefailureOrSuccessOption:
              some(left(const NotificationsFailure.unexpected())),
        ),
      );
    }
  }
}
