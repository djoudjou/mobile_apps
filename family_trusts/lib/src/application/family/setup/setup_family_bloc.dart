import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/invitation/i_spouse_proposal_repository.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/invitation/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class SetupFamilyBloc extends Bloc<SetupFamilyEvent, SetupFamilyState>
    with LogMixin {
  final IUserRepository _userRepository;
  final IFamilyRepository _familyRepository;
  final ISpouseProposalRepository _spouseProposalRepository;
  final INotificationRepository _notificationRepository;
  final AnalyticsSvc _analyticsSvc;

  SetupFamilyBloc(
    this._userRepository,
    this._familyRepository,
    this._spouseProposalRepository,
    this._notificationRepository,
    this._analyticsSvc,
  ) : super(const SetupFamilyState.setupFamilyInitial()) {
    on<EndedSpouseRelationTriggered>(
      _mapEndedSpouseRelationTriggered,
      transformer: restartable(),
    );

    on<AskToJoinFamilyTriggered>(
      _mapSetupFamilyAskToJoinFamilyTriggeredToState,
      transformer: restartable(),
    );

    on<JoinFamilyCancelTriggered>(
      _mapSetupFamilyJoinFamilyCancelTriggeredToState,
      transformer: restartable(),
    );

    on<AcceptInvitationTriggered>(
      _mapAcceptInvitationTriggeredToState,
      transformer: restartable(),
    );

    on<DeclineInvitationTriggered>(
      _mapDeclineInvitationTriggeredToState,
      transformer: restartable(),
    );
  }

  FutureOr<void> _mapSetupFamilyAskToJoinFamilyTriggeredToState(
    AskToJoinFamilyTriggered setupFamilyAskToJoinFamilyTriggered,
    Emitter<SetupFamilyState> emit,
  ) async {
    emit(const SetupFamilyState.setupFamilyAskForJoinFamilyInProgress());
    try {
      final Invitation spouseProposal = Invitation(
        type: InvitationType.spouse(),
        date: TimestampVo.now(),
        from: setupFamilyAskToJoinFamilyTriggered.from,
        to: setupFamilyAskToJoinFamilyTriggered.to,
      );

      final Either<InvitationFailure, Unit> result =
          await _spouseProposalRepository.createSpouseProposal(
        setupFamilyAskToJoinFamilyTriggered.from,
        spouseProposal,
      );

      if (result.isRight()) {
        final Event event = Event(
          date: TimestampVo.now(),
          seen: false,
          from: setupFamilyAskToJoinFamilyTriggered.from,
          to: setupFamilyAskToJoinFamilyTriggered.to,
          type: EventType.spouseProposal(),
          fromConnectedUser: true,
          subject: '',
        );

        await _notificationRepository.createEvent(
          setupFamilyAskToJoinFamilyTriggered.from.id!,
          event,
        );

        final Invitation invitation = Invitation(
          type: InvitationType.spouse(),
          date: TimestampVo.now(),
          from: setupFamilyAskToJoinFamilyTriggered.from,
          to: setupFamilyAskToJoinFamilyTriggered.to,
        );

        await _notificationRepository.createInvitation(invitation);

        emit(const SetupFamilyState.setupFamilyAskForJoinFamilySuccess());
      } else {
        emit(const SetupFamilyState.setupFamilyAskForJoinFamilyFailed());
      }
    } catch (e) {
      emit(const SetupFamilyState.setupFamilyAskForJoinFamilyFailed());
    }
  }

  FutureOr<void> _mapSetupFamilyJoinFamilyCancelTriggeredToState(
    JoinFamilyCancelTriggered event,
    Emitter<SetupFamilyState> emit,
  ) async {
    emit(const SetupFamilyState.setupFamilyJoinFamilyCancelInProgress());
    try {
      final Either<InvitationFailure, Unit> result =
          await _spouseProposalRepository
              .deleteSpouseProposal(event.invitation.from);

      result.fold(
        (l) => _analyticsSvc.debug("delete spouse proposal failed $l"),
        (r) => null,
      );

      if (result.isRight()) {
        await _notificationRepository.createEvent(
          event.invitation.from.id!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: event.invitation.from,
            to: event.invitation.to,
            type: EventType.spouseProposalCanceled(),
            fromConnectedUser: true,
            subject: '',
          ),
        );

        await _notificationRepository.deleteInvitation(
          from: event.invitation.from,
          to: event.invitation.to,
        );

        emit(const SetupFamilyState.setupFamilyJoinFamilyCancelSuccess());
      } else {
        emit(const SetupFamilyState.setupFamilyJoinFamilyCancelFailed());
      }
    } catch (_) {
      emit(const SetupFamilyState.setupFamilyJoinFamilyCancelFailed());
    }
  }

  FutureOr<void> _mapAcceptInvitationTriggeredToState(
    AcceptInvitationTriggered event,
    Emitter<SetupFamilyState> emit,
  ) async {
    emit(const SetupFamilyState.acceptInvitationInProgress());
    try {
      /// lier les personnes
      ///
      ///

      final acceptedProposalUser = event.invitation.to;
      final sentProposalUser = event.invitation.from;
      log("debug acceptedProposalUser = $acceptedProposalUser");
      log("debug sentProposalUser = $sentProposalUser");

      if (quiver.isNotBlank(acceptedProposalUser.spouse)) {
        _endedSpouseRelation(acceptedProposalUser);
      }

      await _userRepository.update(
        sentProposalUser.copyWith(
          familyId: acceptedProposalUser.familyId,
          spouse: acceptedProposalUser.id,
        ),
      );

      await _userRepository.update(
        acceptedProposalUser.copyWith(
          spouse: sentProposalUser.id,
        ),
      );

      await _spouseProposalRepository
          .deleteSpouseProposal(event.invitation.from);

      Future.wait(
        [
          _notificationRepository.createEvent(
            sentProposalUser.id!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: sentProposalUser,
              to: acceptedProposalUser,
              type: EventType.spouseProposalAccepted(),
              fromConnectedUser: true,
              subject: '',
            ),
          ),
          _notificationRepository.createEvent(
            acceptedProposalUser.id!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: sentProposalUser,
              to: acceptedProposalUser,
              type: EventType.spouseProposalAccepted(),
              fromConnectedUser: true,
              subject: '',
            ),
          ),
          _notificationRepository.deleteInvitation(
            from: sentProposalUser,
            to: acceptedProposalUser,
          ),
        ],
      );
      emit(const SetupFamilyState.acceptInvitationSuccess());
    } catch (_) {
      emit(const SetupFamilyState.acceptInvitationFailed());
    }
  }

  FutureOr<void> _mapDeclineInvitationTriggeredToState(
    DeclineInvitationTriggered event,
    Emitter<SetupFamilyState> emit,
  ) async {
    emit(const SetupFamilyState.declineInvitationInProgress());
    try {
      final declinedProposalUser = event.invitation.to;
      final sentProposalUser = event.invitation.from;

      Future.wait(
        [
          _notificationRepository.createEvent(
            sentProposalUser.id!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: sentProposalUser,
              to: declinedProposalUser,
              type: EventType.spouseProposalDeclined(),
              subject: '',
              fromConnectedUser: true,
            ),
          ),
          _notificationRepository.createEvent(
            declinedProposalUser.id!,
            Event(
              date: TimestampVo.now(),
              seen: false,
              from: sentProposalUser,
              to: declinedProposalUser,
              type: EventType.spouseProposalDeclined(),
              fromConnectedUser: true,
              subject: '',
            ),
          ),
          _notificationRepository.deleteInvitation(
            from: sentProposalUser,
            to: declinedProposalUser,
          ),
          _spouseProposalRepository.deleteSpouseProposal(sentProposalUser),
        ],
      );

      emit(const SetupFamilyState.declineInvitationSuccess());
    } catch (_) {
      emit(const SetupFamilyState.declineInvitationFailed());
    }
  }

  FutureOr<void> _mapEndedSpouseRelationTriggered(
    EndedSpouseRelationTriggered event,
    Emitter<SetupFamilyState> emit,
  ) async {
    emit(const SetupFamilyState.endedSpouseRelationInProgress());
    try {
      final from = event.from;
      final to = event.to;

      if (from.spouse == to.id) {
        try {
          Future.wait(
            [
              _notificationRepository.createEvent(
                from.id!,
                Event(
                  date: TimestampVo.now(),
                  seen: false,
                  from: from,
                  to: to,
                  type: EventType.spouseRemoved(),
                  subject: '',
                  fromConnectedUser: true,
                ),
              ),
              _notificationRepository.createEvent(
                to.id!,
                Event(
                  date: TimestampVo.now(),
                  seen: false,
                  from: from,
                  to: to,
                  type: EventType.spouseRemoved(),
                  fromConnectedUser: true,
                  subject: '',
                ),
              ),
              _userRepository.update(to.copyWith(spouse: null)),
              _userRepository
                  .update(from.copyWith(spouse: null, familyId: null)),
            ],
          );
          const SetupFamilyState.endedSpouseRelationSuccess();
        } catch (_) {
          emit(const SetupFamilyState.endedSpouseRelationFailed());
        }
      } else {
        emit(const SetupFamilyState.endedSpouseRelationFailed());
      }
    } catch (_) {
      emit(const SetupFamilyState.endedSpouseRelationFailed());
    }
  }

  Future<void> _endedSpouseRelation(User user) async {
    /// si le "to" a déjà un conjoint > lui retirer les droits sur la famille ainsi que le conjoint "to"
    final Either<UserFailure, User> eitherExSpouse =
        await _userRepository.getUser(user.spouse!);

    eitherExSpouse.fold(
      (userFailure) => null,
      (exSpouse) async {
        final User updatedExSpouse = exSpouse.copyWith(
          familyId: null,
          spouse: null,
        );
        await _userRepository.update(updatedExSpouse);

        /// notifier le futur ex :)
        await _notificationRepository.createEvent(
          exSpouse.id!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: user,
            to: exSpouse,
            type: EventType.spouseRemoved(),
            subject: '',
            fromConnectedUser: true,
          ),
        );
      },
    );
  }
}
