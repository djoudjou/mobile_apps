import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:injectable/injectable.dart';

import 'notifications_events_update_event.dart';
import 'notifications_events_update_state.dart';

@injectable
class NotificationsEventsUpdateBloc extends Bloc<NotificationsEventsUpdateEvent,
    NotificationsEventsUpdateState> {
  final INotificationRepository _notificationRepository;

  NotificationsEventsUpdateBloc(this._notificationRepository)
      : super(NotificationsEventsUpdateState.initial());

  @override
  Stream<NotificationsEventsUpdateState> mapEventToState(
      NotificationsEventsUpdateEvent event) async* {
    yield* event.map(
      markAsRead: (event) {
        return _mapMarkAsReadToState(event);
      },
      deleteEvent: (DeleteEvent event) {
        return _mapDeleteNotificationToState(event);
      },
    );
  }

  Stream<NotificationsEventsUpdateState> _mapMarkAsReadToState(
      MarkAsRead event) async* {
    try {
      yield state.copyWith(
        markAsReadInProgress: true,
        markAsReadfailureOrSuccessOption: none(),
      );
      final Either<NotificationsFailure, Unit> result =
          await _notificationRepository.updateEvent(
        event.currentUser.id!,
        event.notification.copyWith(seen: true),
      );
      yield result.fold(
        (l) => state.copyWith(
          markAsReadInProgress: false,
          markAsReadfailureOrSuccessOption: some(left(l)),
        ),
        (r) => state.copyWith(
          markAsReadInProgress: false,
          markAsReadfailureOrSuccessOption: some(right(unit)),
        ),
      );
    } catch (execption) {
      yield state.copyWith(
        markAsReadInProgress: false,
        markAsReadfailureOrSuccessOption:
            some(left(const NotificationsFailure.unexpected())),
      );
    }
  }

  Stream<NotificationsEventsUpdateState> _mapDeleteNotificationToState(
      DeleteEvent event) async* {
    try {
      yield state.copyWith(
        isDeleting: true,
        deletefailureOrSuccessOption: none(),
      );
      final Either<NotificationsFailure, Unit> result =
          await _notificationRepository.deleteEvent(
        event.currentUser.id!,
        event.notification,
      );

      yield result.fold(
        (l) => state.copyWith(
          isDeleting: false,
          deletefailureOrSuccessOption: some(left(l)),
        ),
        (r) => state.copyWith(
          isDeleting: false,
          deletefailureOrSuccessOption: some(right(unit)),
        ),
      );
    } catch (execption) {
      yield state.copyWith(
        isDeleting: false,
        deletefailureOrSuccessOption:
            some(left(const NotificationsFailure.unexpected())),
      );
    }
  }
}
