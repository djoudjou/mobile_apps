import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import '../bloc.dart';
import 'children_form_state.dart';

@injectable
class ChildrenFormBloc extends Bloc<ChildrenFormEvent, ChildrenFormState> {
  final IFamilyRepository _familyRepository;
  final INotificationRepository _notificationRepository;

  ChildrenFormBloc(
    this._familyRepository,
    this._notificationRepository,
  ) : super(const ChildrenFormState.init());

  @override
  Stream<ChildrenFormState> mapEventToState(
      ChildrenFormEvent event,
  ) async* {
    yield* event.map(
      addChild: (event) {
        return _mapAddChildToState(event);
      },
      updateChild: (event) {
        return _mapUpdateChildToState(event);
      },
      deleteChild: (event) {
        return _mapDeleteChildToState(event);
      },
    );
  }

  Stream<ChildrenFormState> _mapAddChildToState(AddChild event) async* {
    try {
      yield const ChildrenFormState.addChildInProgress();
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.familyId!,
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
      yield const ChildrenFormState.addChildSuccess();
    } catch (_) {
      yield const ChildrenFormState.addChildFailure();
    }
  }

  Stream<ChildrenFormState> _mapUpdateChildToState(UpdateChild event) async* {
    try {
      yield const ChildrenFormState.updateChildInProgress();
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.familyId!,
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
      yield const ChildrenFormState.updateChildSuccess();
    } catch (_) {
      yield const ChildrenFormState.updateChildFailure();
    }
  }

  Stream<ChildrenFormState> _mapDeleteChildToState(DeleteChild event) async* {
    try {
      yield const ChildrenFormState.deleteChildInProgress();
      final User user = event.user;
      await _familyRepository.deleteChild(
        familyId: user.familyId!,
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
      yield const ChildrenFormState.deleteChildSuccess();
    } catch (_) {
      yield const ChildrenFormState.deleteChildFailure();
    }
  }
}
