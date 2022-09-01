import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_join_proposal_state.freezed.dart';

@freezed
class FamilyJoinProposalState with _$FamilyJoinProposalState {
  const factory FamilyJoinProposalState.initial() = Initial;

  const factory FamilyJoinProposalState.joinProposalAcceptInProgress() =
      JoinProposalAcceptInProgress;

  const factory FamilyJoinProposalState.joinProposalAcceptSuccess() =
      JoinProposalAcceptSuccess;

  const factory FamilyJoinProposalState.joinProposalAcceptFailure(
    String error,
  ) = JoinProposalAcceptFailure;

  const factory FamilyJoinProposalState.joinProposalDeclineInProgress() =
      JoinProposalDeclineInProgress;

  const factory FamilyJoinProposalState.joinProposalDeclineSuccess() =
      JoinProposalDeclineSuccess;

  const factory FamilyJoinProposalState.joinProposalDeclineFailure(
    String error,
  ) = JoinProposalDeclineFailure;

  const factory FamilyJoinProposalState.joinProposalsLoadInProgress() =
      FamilyJoinProposalsLoadInProgress;

  const factory FamilyJoinProposalState.joinProposalsLoaded({
    required bool hasPendingProposals,
    required List<JoinProposal> pendingProposals,
  }) = FamilyJoinProposalsLoaded;

  const factory FamilyJoinProposalState.joinProposalsLoadFailure(String error) =
      FamilyJoinProposalsLoadFailure;
}
