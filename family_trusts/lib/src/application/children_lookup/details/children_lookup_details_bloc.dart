import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChildrenLookupDetailsBloc
    extends Bloc<ChildrenLookupDetailsEvent, ChildrenLookupDetailsState> {
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;
  final IChildrenLookupRepository _childrenLookupRepository;
  final INotificationRepository _notificationRepository;

  StreamSubscription? _childrenLookupHistorySubscription;
  StreamSubscription? _childrenLookupSubscription;

  ChildrenLookupDetailsBloc(
    this._authFacade,
    this._userRepository,
    this._childrenLookupRepository,
    this._notificationRepository,
  ) : super(ChildrenLookupDetailsState.initial()) {
    on<ChildrenLookupDetailsEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  Future<void> mapEventToState(
    ChildrenLookupDetailsEvent event,
    Emitter<ChildrenLookupDetailsState> emit,
  ) async {
    event.map(
      childrenLookupUpdated: (ChildrenLookupUpdated value) async {
        final ChildrenLookup childrenLookup =
            value.eitherChildrenLookup.toOption().toNullable()!;

        final User? connectedUser = await getConnectedUser();

        if (connectedUser != null) {
          emit(
            state.copyWith(
              childrenLookup: childrenLookup,
              isTrustedUser: isTrustedUser(connectedUser, childrenLookup),
              displayDeclineButton:
                  isDeclineButtonEnable(connectedUser, childrenLookup),
              displayAcceptButton:
                  isAcceptButtonEnable(connectedUser, childrenLookup),
              displayEndedButton: isEndedButtonEnable(
                connectedUser,
                childrenLookup.rendezVous.value.toOption().toNullable()!,
                childrenLookup,
              ),
              displayCancelButton:
                  isCancelButtonEnable(connectedUser, childrenLookup),
              isIssuer: connectedUser.id == childrenLookup.issuer?.id,
              failureOrSuccessOption: none(),
            ),
          );
        }
      },
      init: (ChildrenLookupDetailsInit value) async {
        final User? connectedUser = await getConnectedUser();

        if (connectedUser == null) {
          emit(
            state.copyWith(
              isInitializing: false,
              failureOrSuccessOption: some(
                left(
                  const ChildrenLookupFailure.userNotConnected(),
                ),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              isInitializing: true,
            ),
          );

          _childrenLookupHistorySubscription?.cancel();
          _childrenLookupHistorySubscription = _childrenLookupRepository
              .getChildrenLookupHistories(
            childrenLookupId: value.childrenLookup.id!,
          )
              .listen(
            (event) {
              add(
                ChildrenLookupDetailsEvent.childrenLookupHistoriesUpdated(
                  eitherChildrenHistory: event,
                ),
              );
            },
            onError: (_) => _childrenLookupHistorySubscription?.cancel(),
          );

          _childrenLookupSubscription?.cancel();
          _childrenLookupSubscription = _childrenLookupRepository
              .watchChildrenLookup(childrenLookupId: value.childrenLookup.id!)
              .listen(
            (e) {
              add(
                ChildrenLookupDetailsEvent.childrenLookupUpdated(
                  eitherChildrenLookup: e,
                ),
              );
            },
            onError: (_) => _childrenLookupSubscription?.cancel(),
          );

          emit(
            state.copyWith(
              childrenLookup: value.childrenLookup,
              isTrustedUser: isTrustedUser(connectedUser, value.childrenLookup),
              displayDeclineButton:
                  isDeclineButtonEnable(connectedUser, value.childrenLookup),
              displayAcceptButton:
                  isAcceptButtonEnable(connectedUser, value.childrenLookup),
              displayEndedButton: isEndedButtonEnable(
                connectedUser,
                value.childrenLookup.rendezVous.value.toOption().toNullable()!,
                value.childrenLookup,
              ),
              displayCancelButton:
                  isCancelButtonEnable(connectedUser, value.childrenLookup),
              isIssuer: connectedUser.id == value.childrenLookup.issuer?.id,
              failureOrSuccessOption: none(),
              isInitializing: false,
            ),
          );
        }
      },
      childrenLookupHistoriesUpdated: (ChildrenLookupHistoryUpdated value) {
        final List<ChildrenLookupHistory> childrenlookupHistory = value
            .eitherChildrenHistory
            .where((e) => e.isRight())
            .map((e) => e.toOption().toNullable()!)
            .toList();
        emit(
          state.copyWith(
            optionEitherChildrenLookupHistory:
                some(right(childrenlookupHistory)),
            failureOrSuccessOption: none(),
          ),
        );
      },
      decline: (ChildrenLookupDetailsDecline value) async {
        final User? connectedUser = await getConnectedUser();
        if (state.childrenLookup != null &&
            state.isTrustedUser &&
            state.displayDeclineButton &&
            connectedUser != null) {
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );

          await _childrenLookupRepository.addChildrenLookupHistory(
            childrenLookupId: state.childrenLookup!.id!,
            childrenLookupHistory: ChildrenLookupHistory(
              id: UniqueId().getOrCrash(),
              creationDate: TimestampVo.now(),
              subject: connectedUser,
              eventType: MissionEventType.declined(),
              message:
                  LocaleKeys.ask_childlookup_notification_declined_template.tr(
                args: [
                  connectedUser.displayName,
                  childrenLookupMsg(state.childrenLookup!),
                ],
              ),
            ),
          );

          await _childrenLookupRepository.addUpdateChildrenLookup(
            childrenLookup: state.childrenLookup!.copyWith(
              state: MissionState.waiting(),
              personInCharge: null,
            ),
          );

          await _notificationRepository.createEventForChildrenLookup(
            state.childrenLookup!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: connectedUser,
              to: connectedUser,
              type: EventType.childrenLookupDecline(),
              subject: childrenLookupMsg(state.childrenLookup!),
              fromConnectedUser: true,
            ),
          );

          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: some(right(unit)),
            ),
          );
        }
      },
      accept: (ChildrenLookupDetailsAccept value) async {
        final User? connectedUser = await getConnectedUser();
        if (state.childrenLookup != null &&
            state.isTrustedUser &&
            state.displayAcceptButton &&
            connectedUser != null) {
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );

          await _childrenLookupRepository.addChildrenLookupHistory(
            childrenLookupId: state.childrenLookup!.id!,
            childrenLookupHistory: ChildrenLookupHistory(
              id: UniqueId().getOrCrash(),
              creationDate: TimestampVo.now(),
              subject: connectedUser,
              eventType: MissionEventType.accepted(),
              message:
                  LocaleKeys.ask_childlookup_notification_accepted_template.tr(
                args: [
                  connectedUser.displayName,
                  childrenLookupMsg(state.childrenLookup!),
                ],
              ),
            ),
          );

          await _childrenLookupRepository.addUpdateChildrenLookup(
            childrenLookup: state.childrenLookup!.copyWith(
              state: MissionState.accepted(),
              personInCharge: connectedUser,
            ),
          );

          await _notificationRepository.createEventForChildrenLookup(
            state.childrenLookup!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: connectedUser,
              to: connectedUser,
              type: EventType.childrenLookupAccepted(),
              subject: childrenLookupMsg(state.childrenLookup!),
              fromConnectedUser: true,
            ),
          );

          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: some(right(unit)),
            ),
          );
        }
      },
      cancel: (ChildrenLookupDetailsCancel value) async {
        final User? connectedUser = await getConnectedUser();
        if (state.childrenLookup != null &&
            state.isTrustedUser &&
            state.displayCancelButton &&
            connectedUser != null) {
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );

          await _childrenLookupRepository.addChildrenLookupHistory(
            childrenLookupId: state.childrenLookup!.id!,
            childrenLookupHistory: ChildrenLookupHistory(
              id: UniqueId().getOrCrash(),
              creationDate: TimestampVo.now(),
              subject: connectedUser,
              eventType: MissionEventType.canceled(),
              message:
                  LocaleKeys.ask_childlookup_notification_canceled_template.tr(
                args: [
                  connectedUser.displayName,
                  childrenLookupMsg(state.childrenLookup!),
                ],
              ),
            ),
          );

          await _childrenLookupRepository.addUpdateChildrenLookup(
            childrenLookup: state.childrenLookup!.copyWith(
              state: MissionState.canceled(),
            ),
          );

          await _notificationRepository.createEventForChildrenLookup(
            state.childrenLookup!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: connectedUser,
              to: connectedUser,
              type: EventType.childrenLookupCanceled(),
              subject: childrenLookupMsg(state.childrenLookup!),
              fromConnectedUser: true,
            ),
          );

          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: some(right(unit)),
            ),
          );
        }
      },
      ended: (ChildrenLookupDetailsEnded value) async {
        final User? connectedUser = await getConnectedUser();
        if (state.childrenLookup != null &&
            state.isTrustedUser &&
            state.displayEndedButton &&
            connectedUser != null) {
          emit(
            state.copyWith(
              isSubmitting: true,
              failureOrSuccessOption: none(),
            ),
          );

          await _childrenLookupRepository.addChildrenLookupHistory(
            childrenLookupId: state.childrenLookup!.id!,
            childrenLookupHistory: ChildrenLookupHistory(
              id: UniqueId().getOrCrash(),
              creationDate: TimestampVo.now(),
              subject: connectedUser,
              eventType: MissionEventType.ended(),
              message:
                  LocaleKeys.ask_childlookup_notification_ended_template.tr(
                args: [
                  connectedUser.displayName,
                  state.childrenLookup!.child!.displayName,
                ],
              ),
            ),
          );

          await _childrenLookupRepository.addUpdateChildrenLookup(
            childrenLookup: state.childrenLookup!.copyWith(
              state: MissionState.ended(),
            ),
          );

          await _notificationRepository.createEventForChildrenLookup(
            state.childrenLookup!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: connectedUser,
              to: connectedUser,
              type: EventType.childrenLookupEnded(),
              subject: childrenLookupMsg(state.childrenLookup!),
              fromConnectedUser: true,
            ),
          );

          emit(
            state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: some(right(unit)),
            ),
          );
        }
      },
    );
  }

  Future<User?> getConnectedUser() async {
    final String userId = _authFacade.getSignedInUserId().toNullable()!;
    final Either<UserFailure, User> eitherUser =
        await _userRepository.getUser(userId);
    final Option<User> connectedUserOption =
        eitherUser.fold((l) => none(), (r) => some(r));

    return connectedUserOption.toNullable();
  }

  String childrenLookupMsg(ChildrenLookup childrenLookup) {
    return LocaleKeys.ask_childlookup_notification_template.tr(
      args: [
        childrenLookup.child!.displayName,
        childrenLookup.location!.title.getOrCrash(),
        childrenLookup.rendezVous.toText,
      ],
    );
  }

  bool isTrustedUser(User connectedUser, ChildrenLookup childrenLookup) =>
      childrenLookup.trustedUsers.contains(connectedUser.id);

  bool isDeclineButtonEnable(
    User connectedUser,
    ChildrenLookup childrenLookup,
  ) =>
      childrenLookup.state == MissionState.accepted() &&
      childrenLookup.personInCharge != null &&
      childrenLookup.personInCharge?.id == connectedUser.id;

  bool isCancelButtonEnable(
    User connectedUser,
    ChildrenLookup childrenLookup,
  ) =>
      childrenLookup.state == MissionState.waiting() &&
      childrenLookup.issuer?.id == connectedUser.id;

  bool isAcceptButtonEnable(
    User connectedUser,
    ChildrenLookup childrenLookup,
  ) =>
      childrenLookup.state == MissionState.waiting() &&
      childrenLookup.personInCharge?.id == null &&
      childrenLookup.issuer?.id != connectedUser.id;

  bool isEndedButtonEnable(
    User connectedUser,
    DateTime rendezVous,
    ChildrenLookup childrenLookup,
  ) =>
      childrenLookup.state == MissionState.accepted() &&
      childrenLookup.personInCharge != null &&
      childrenLookup.personInCharge?.id == connectedUser.id &&
      DateTime.now().isAfter(rendezVous);

  @override
  Future<void> close() {
    _childrenLookupHistorySubscription?.cancel();
    _childrenLookupSubscription?.cancel();
    return super.close();
  }
}
