import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class ChildrenFormBloc extends Bloc<ChildrenFormEvent, ChildrenFormState> {
  final IFamilyRepository _familyRepository;
  final INotificationRepository _notificationRepository;

  ChildrenFormBloc(
    this._familyRepository,
    this._notificationRepository,
  ) : super(const ChildrenFormState.init()) {
    on<ChildrenFormEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  Future<void> mapEventToState(
    ChildrenFormEvent event,
    Emitter<ChildrenFormState> emit,
  ) async {
    event.map(
      addChild: (event) {
        _mapAddChildToState(event, emit);
      },
      updateChild: (event) {
        _mapUpdateChildToState(event, emit);
      },
      deleteChild: (event) {
        _mapDeleteChildToState(event, emit);
      },
    );
  }

  FutureOr<void> _mapAddChildToState(
    AddChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.addChildInProgress());
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.family!.id!,
        child: event.child,
        pickedFilePath: event.pickedFilePath,
      );
      await _notificationRepository.createEvent(
        user.id!,
        Event(
          date: TimestampVo.now(),
          seen: false,
          from: user,
          to: user,
          subject: event.child.displayName,
          type: EventType.childAdded(),
          fromConnectedUser: true,
        ),
      );
      if (quiver.isNotBlank(user.spouse)) {
        await _notificationRepository.createEvent(
          user.spouse!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: user,
            to: user,
            subject: event.child.displayName,
            type: EventType.childAdded(),
            fromConnectedUser: true,
          ),
        );
      }
      emit(const ChildrenFormState.addChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.addChildFailure());
    }
  }

  FutureOr<void> _mapUpdateChildToState(
    UpdateChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.updateChildInProgress());
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.family!.id!,
        child: event.child,
        pickedFilePath: event.pickedFilePath,
      );
      await _notificationRepository.createEvent(
        user.id!,
        Event(
          date: TimestampVo.now(),
          seen: false,
          from: user,
          to: user,
          type: EventType.childUpdated(),
          subject: event.child.displayName,
          fromConnectedUser: true,
        ),
      );
      if (quiver.isNotBlank(user.spouse)) {
        await _notificationRepository.createEvent(
          user.spouse!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: user,
            to: user,
            subject: event.child.displayName,
            type: EventType.childUpdated(),
            fromConnectedUser: true,
          ),
        );
      }
      emit(const ChildrenFormState.updateChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.updateChildFailure());
    }
  }

  FutureOr<void> _mapDeleteChildToState(
    DeleteChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.deleteChildInProgress());
      final User user = event.user;
      await _familyRepository.deleteChild(
        familyId: user.family!.id!,
        child: event.child,
      );

      await _notificationRepository.createEvent(
        user.id!,
        Event(
          date: TimestampVo.now(),
          seen: false,
          from: user,
          to: user,
          subject: event.child.displayName,
          type: EventType.childRemoved(),
          fromConnectedUser: true,
        ),
      );

      if (quiver.isNotBlank(user.spouse)) {
        await _notificationRepository.createEvent(
          user.spouse!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: user,
            to: user,
            subject: event.child.displayName,
            type: EventType.childRemoved(),
            fromConnectedUser: true,
          ),
        );
      }
      emit(const ChildrenFormState.deleteChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.deleteChildFailure());
    }
  }
}
