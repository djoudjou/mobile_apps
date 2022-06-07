import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_family_state.freezed.dart';


@freezed
abstract class SetupFamilyState implements _$SetupFamilyState {
  const factory SetupFamilyState.setupFamilyInitial() = _SetupFamilyInitial;
  const factory SetupFamilyState.setupFamilyNewFamilyInProgress() = _SetupFamilyNewFamilyInProgress;
  const factory SetupFamilyState.setupFamilyNewFamilySuccess() = _SetupFamilyNewFamilySuccess;
  const factory SetupFamilyState.setupFamilyNewFamilyFailed() = _SetupFamilyNewFamilyFailed;

  const factory SetupFamilyState.setupFamilyAskForJoinFamilyInProgress() = _SetupFamilyAskForJoinFamilyInProgress;
  const factory SetupFamilyState.setupFamilyAskForJoinFamilySuccess() = _SetupFamilyAskForJoinFamilySuccess;
  const factory SetupFamilyState.setupFamilyAskForJoinFamilyFailed() = _SetupFamilyAskForJoinFamilyFailed;

  const factory SetupFamilyState.setupFamilyJoinFamilyCancelInProgress() = _SetupFamilyJoinFamilyCancelInProgress;
  const factory SetupFamilyState.setupFamilyJoinFamilyCancelSuccess() = _SetupFamilyJoinFamilyCancelSuccess;
  const factory SetupFamilyState.setupFamilyJoinFamilyCancelFailed() = _SetupFamilyJoinFamilyCancelFailed;

  const factory SetupFamilyState.acceptInvitationInProgress() = _AcceptInvitationInProgress;
  const factory SetupFamilyState.acceptInvitationSuccess() = _AcceptInvitationSuccess;
  const factory SetupFamilyState.acceptInvitationFailed() = _AcceptInvitationFailed;

  const factory SetupFamilyState.declineInvitationInProgress() = _DeclineInvitationInProgress;
  const factory SetupFamilyState.declineInvitationSuccess() = _DeclineInvitationSuccess;
  const factory SetupFamilyState.declineInvitationFailed() = _DeclineInvitationFailed;

  const factory SetupFamilyState.endedSpouseRelationInProgress() = _EndedSpouseRelationInProgress;
  const factory SetupFamilyState.endedSpouseRelationSuccess() = _EndedSpouseRelationSuccess;
  const factory SetupFamilyState.endedSpouseRelationFailed() = _EndedSpouseRelationFailed;
}
