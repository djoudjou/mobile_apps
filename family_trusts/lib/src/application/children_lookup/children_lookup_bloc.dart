import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class ChildrenLookupBloc
    extends Bloc<ChildrenLookupEvent, ChildrenLookupState> {
  static const bounceDuration = Duration(milliseconds: 500);
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;
  final IFamilyRepository _familyRepository;
  final IChildrenLookupRepository _childrenLookupRepository;
  final INotificationRepository _notificationRepository;

  StreamSubscription? _childrenSubscription;
  StreamSubscription? _locationsSubscription;

  ChildrenLookupBloc(
    this._authFacade,
    this._userRepository,
    this._familyRepository,
    this._childrenLookupRepository,
    this._notificationRepository,
  ) : super(ChildrenLookupState.initial()) {
    on<ChildrenLookupEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: debounce(bounceDuration),
    );
  }

  Future<void> mapEventToState(
    ChildrenLookupEvent event,
    Emitter<ChildrenLookupState> emit,
  ) async {
    event.map(
      init: (ChildrenLookupInit e) {
        if (quiver.isBlank(e.familyId)) {
          emit(
            state.copyWith(
              failureOrSuccessOption:
                  some(left(const ChildrenLookupFailure.noFamily())),
            ),
          );
        } else {
          /*
      TODO ADJ no more stream
          _childrenSubscription?.cancel();
          _childrenSubscription =
              _familyRepository.getChildren(e.familyId!).listen((event) {
            add(ChildrenLookupEvent.childrenUpdated(eitherChildren: event));
          });

          _locationsSubscription?.cancel();
          _locationsSubscription =
              _familyRepository.getLocations(e.familyId!).listen(
            (event) {
              add(ChildrenLookupEvent.locationsUpdated(eitherLocations: event));
            },
            onError: (_) {
              _locationsSubscription?.cancel();
            },
          );

          emit(
            state.copyWith(
              isInitializing: false,
              showErrorMessages: true,
              familyId: e.familyId,
            ),
          );

           */
        }
      },
      noteChanged: (NoteChanged e) {
        emit(
          state.copyWith(
            notesStep: state.notesStep.copyWith(noteBody: NoteBody(e.note)),
            failureOrSuccessOption: none(),
          ),
        );
      },
      rendezVousChanged: (RendezVousChanged value) {
        emit(
          state.copyWith(
            rendezVousStep: state.rendezVousStep
                .copyWith(rendezVous: RendezVous.fromDate(value.dateTime)),
            failureOrSuccessOption: none(),
          ),
        );
      },
      childrenUpdated: (ChildrenUpdated value) {
        emit(
          state.copyWith(
            childrenStep: state.childrenStep
                .copyWith(optionEitherChildren: some(value.eitherChildren)),
            failureOrSuccessOption: none(),
          ),
        );
      },
      locationsUpdated: (LocationsUpdated value) {
        emit(
          state.copyWith(
            locationsStep: state.locationsStep
                .copyWith(optionEitherLocations: some(value.eitherLocations)),
            failureOrSuccessOption: none(),
          ),
        );
      },
      childSelected: (ChildSelected value) {
        emit(
          state.copyWith(
            childrenStep:
                state.childrenStep.copyWith(selectedChild: value.child),
            failureOrSuccessOption: none(),
          ),
        );
        //add(const Next());
      },
      locationSelected: (LocationSelected value) {
        emit(
          state.copyWith(
            locationsStep:
                state.locationsStep.copyWith(selectedLocation: value.location),
            failureOrSuccessOption: none(),
          ),
        );
        //add(const Next());
      },
      submitted: (Submitted value) async {
        emit(
          state.copyWith(
            isSubmitting: true,
            failureOrSuccessOption: none(),
          ),
        );

        final String userId =
            _authFacade.getSignedInUserId().getOrElse(() => "");
        final Either<UserFailure, User> eitherUser =
            await _userRepository.getUser(userId);

        final Either<UserFailure, List<TrustedUser>> eitherTrustedUsers =
            await _familyRepository.getFutureTrustedUsers(state.familyId!);

        if (eitherUser.isRight() && eitherTrustedUsers.isRight()) {
          final User user = eitherUser.toOption().toNullable()!;

          final childrenLookupId = UniqueId().getOrCrash();

          final List<String> trustedUsers = eitherTrustedUsers
              .getOrElse(() => <TrustedUser>[])
              .map((e) => e.user.id!)
              .toList();

          final childrenLookup = ChildrenLookup(
            id: childrenLookupId,
            rendezVous: state.rendezVousStep.rendezVous,
            noteBody: state.notesStep.noteBody,
            child: state.childrenStep.selectedChild,
            creationDate: TimestampVo.now(),
            issuer: user,
            location: state.locationsStep.selectedLocation,
            state: MissionState.waiting(),
            trustedUsers: trustedUsers,
          );

          await _childrenLookupRepository.addUpdateChildrenLookup(
            childrenLookup: childrenLookup,
          );

          await _childrenLookupRepository.addChildrenLookupHistory(
            childrenLookupId: childrenLookupId,
            childrenLookupHistory: ChildrenLookupHistory(
              id: UniqueId().getOrCrash(),
              creationDate: TimestampVo.now(),
              subject: user,
              eventType: MissionEventType.created(),
              message:
                  LocaleKeys.ask_childlookup_notification_created_template.tr(
                args: [
                  user.displayName,
                  childrenLookupMsg(),
                ],
              ),
            ),
          );

          await _notificationRepository.createEventForChildrenLookup(
            childrenLookup,
            Event(
              date: TimestampVo.now(),
              seen: false,
              fromConnectedUser: true,
              from: user,
              to: user,
              type: EventType.childrenLookupAdded(),
              subject: childrenLookupMsg(),
            ),
          );

          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: some(right(unit)),
            ),
          );
        } else {
          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption:
                  some(left(const ChildrenLookupFailure.userNotConnected())),
            ),
          );
        }
      },
      next: (Next value) async* {
        if (state.currentStep + 1 < 4) {
          add(Goto(state.currentStep + 1));
        } else {
          emit(
            state.copyWith(
              isCompleted: isValid(),
            ),
          );
        }
      },
      cancel: (Cancel value) async* {
        if (state.currentStep > 0) {
          add(Goto(state.currentStep - 1));
        }
        emit(
          state.copyWith(
            isCompleted: false,
          ),
        );
      },
      goTo: (Goto value) async* {
        emit(
          state.copyWith(
            currentStep: value.step,
            childrenStep:
                state.childrenStep.copyWith(isActive: value.step == 0),
            locationsStep:
                state.locationsStep.copyWith(isActive: value.step == 1),
            rendezVousStep:
                state.rendezVousStep.copyWith(isActive: value.step == 2),
            notesStep: state.notesStep.copyWith(isActive: value.step == 3),
            //isCompleted: isValid(),
          ),
        );
      },
    );
  }

  String childrenLookupMsg() {
    return LocaleKeys.ask_childlookup_notification_template.tr(
      args: [
        state.childrenStep.selectedChild!.displayName,
        state.locationsStep.selectedLocation!.title.getOrCrash(),
        state.rendezVousStep.rendezVous.toText,
      ],
    );
  }

  bool isValid() {
    return state.childrenStep.selectedChild != null &&
        state.locationsStep.selectedLocation != null &&
        state.rendezVousStep.rendezVous.isValid() &&
        state.notesStep.noteBody.isValid();
  }

  @override
  Future<void> close() {
    _childrenSubscription?.cancel();
    _locationsSubscription?.cancel();
    return super.close();
  }
}
