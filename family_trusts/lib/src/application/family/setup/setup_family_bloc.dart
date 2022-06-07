import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
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
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;
import 'package:familytrusts/src/helper/log_mixin.dart';

import 'bloc.dart';

@injectable
class SetupFamilyBloc extends Bloc<SetupFamilyEvent, SetupFamilyState>
    with LogMixin {
  final IUserRepository _userRepository;
  final ISpouseProposalRepository _spouseProposalRepository;
  final INotificationRepository _notificationRepository;
  final AnalyticsSvc _analyticsSvc;

  SetupFamilyBloc(
    this._userRepository,
    this._spouseProposalRepository,
    this._notificationRepository,
    this._analyticsSvc,
  ) : super(const SetupFamilyState.setupFamilyInitial());

  @override
  Stream<SetupFamilyState> mapEventToState(
    SetupFamilyEvent event,
  ) async* {
    yield* event.map(
      newFamilyCreationTriggered: (event) {
        return _mapNewFamilyCreationTriggeredToState(event);
      },
      askToJoinFamilyTriggered: (event) {
        return _mapSetupFamilyAskToJoinFamilyTriggeredToState(event);
      },
      joinFamilyCancelTriggered: (event) {
        return _mapSetupFamilyJoinFamilyCancelTriggeredToState(
            event.invitation);
      },
      acceptInvitationTriggered: (event) {
        return _mapAcceptInvitationTriggeredToState(event);
      },
      declineInvitationTriggered: (event) {
        return _mapDeclineInvitationTriggeredToState(event);
      },
      endedSpouseRelationTriggered: (event) {
        return _mapEndedSpouseRelationTriggered(event);
      },
    );
  }

  Stream<SetupFamilyState> _mapNewFamilyCreationTriggeredToState(
    NewFamilyCreationTriggered event,
  ) async* {
    yield const SetupFamilyState.setupFamilyNewFamilyInProgress();
    try {
      final Either<InvitationFailure, Invitation?> eitherSpouseProposal =
          await _spouseProposalRepository.getSpouseProposal(event.user.id!);

      if (eitherSpouseProposal.isRight()) {
        /// Si une proposition en cours, on l'annule
        _mapSetupFamilyJoinFamilyCancelTriggeredToState(
            eitherSpouseProposal.toOption().toNullable()!);
      }
      await _userRepository
          .update(event.user.copyWith(familyId: UniqueId().getOrCrash()));

      yield const SetupFamilyState.setupFamilyNewFamilySuccess();
    } catch (_) {
      yield const SetupFamilyState.setupFamilyNewFamilyFailed();
    }
  }

  Stream<SetupFamilyState> _mapSetupFamilyAskToJoinFamilyTriggeredToState(
    AskToJoinFamilyTriggered setupFamilyAskToJoinFamilyTriggered,
  ) async* {
    yield const SetupFamilyState.setupFamilyAskForJoinFamilyInProgress();
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
            setupFamilyAskToJoinFamilyTriggered.from.id!, event);

        final Invitation invitation = Invitation(
          type: InvitationType.spouse(),
          date: TimestampVo.now(),
          from: setupFamilyAskToJoinFamilyTriggered.from,
          to: setupFamilyAskToJoinFamilyTriggered.to,
        );

        await _notificationRepository.createInvitation(invitation);

        yield const SetupFamilyState.setupFamilyAskForJoinFamilySuccess();
      } else {
        yield const SetupFamilyState.setupFamilyAskForJoinFamilyFailed();
      }
    } catch (e) {
      yield const SetupFamilyState.setupFamilyAskForJoinFamilyFailed();
    }
  }

  Stream<SetupFamilyState> _mapSetupFamilyJoinFamilyCancelTriggeredToState(
    Invitation invitation,
  ) async* {
    yield const SetupFamilyState.setupFamilyJoinFamilyCancelInProgress();
    try {
      final Either<InvitationFailure, Unit> result =
          await _spouseProposalRepository.deleteSpouseProposal(invitation.from);

      result.fold(
          (l) => _analyticsSvc.debug("delete spouse proposal failed $l"),
          (r) => null);

      if (result.isRight()) {
        await _notificationRepository.createEvent(
          invitation.from.id!,
          Event(
            date: TimestampVo.now(),
            seen: false,
            from: invitation.from,
            to: invitation.to,
            type: EventType.spouseProposalCanceled(),
            fromConnectedUser: true,
            subject: '',
          ),
        );

        await _notificationRepository.deleteInvitation(
          from: invitation.from,
          to: invitation.to,
        );

        yield const SetupFamilyState.setupFamilyJoinFamilyCancelSuccess();
      } else {
        yield const SetupFamilyState.setupFamilyJoinFamilyCancelFailed();
      }
    } catch (_) {
      yield const SetupFamilyState.setupFamilyJoinFamilyCancelFailed();
    }
  }

  Stream<SetupFamilyState> _mapAcceptInvitationTriggeredToState(
      AcceptInvitationTriggered event) async* {
    yield const SetupFamilyState.acceptInvitationInProgress();
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

      await _userRepository.update(sentProposalUser.copyWith(
        familyId: acceptedProposalUser.familyId,
        spouse: acceptedProposalUser.id,
      ));

      await _userRepository.update(acceptedProposalUser.copyWith(
        spouse: sentProposalUser.id,
      ));

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
      yield const SetupFamilyState.acceptInvitationSuccess();
    } catch (_) {
      yield const SetupFamilyState.acceptInvitationFailed();
    }
  }

  Stream<SetupFamilyState> _mapDeclineInvitationTriggeredToState(
      DeclineInvitationTriggered event) async* {
    yield const SetupFamilyState.declineInvitationInProgress();
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

      yield const SetupFamilyState.declineInvitationSuccess();
    } catch (_) {
      yield const SetupFamilyState.declineInvitationFailed();
    }
  }

  Stream<SetupFamilyState> _mapEndedSpouseRelationTriggered(
      EndedSpouseRelationTriggered event) async* {
    yield const SetupFamilyState.endedSpouseRelationInProgress();
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
          yield const SetupFamilyState.endedSpouseRelationFailed();
        }
      } else {
        yield const SetupFamilyState.endedSpouseRelationFailed();
      }
    } catch (_) {
      yield const SetupFamilyState.endedSpouseRelationFailed();
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
