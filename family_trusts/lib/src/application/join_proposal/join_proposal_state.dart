import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_proposal_state.freezed.dart';

@freezed
class JoinProposalState with _$JoinProposalState {
  const factory JoinProposalState.initial() = Initial;

  const factory JoinProposalState.joinProposalSendInProgress() =
      JoinProposalSendInProgress;

  const factory JoinProposalState.joinProposalSendSuccess() =
      JoinProposalSendSuccess;

  const factory JoinProposalState.joinProposalSendFailure(String error) =
      JoinProposalSendFailure;

  const factory JoinProposalState.joinProposalCancelInProgress() =
      JoinProposalCancelInProgress;

  const factory JoinProposalState.joinProposalCancelSuccess() =
      JoinProposalCancelSuccess;

  const factory JoinProposalState.joinProposalCancelFailure(String error) =
      JoinProposalCancelFailure;

  const factory JoinProposalState.joinProposalsLoadInProgress() =
      JoinProposalsLoadInProgress;

  const factory JoinProposalState.joinProposalsLoaded({
    required bool hasProposals,
    required List<JoinProposal> joinProposals,
  }) = JoinProposalsLoaded;

  const factory JoinProposalState.joinProposalsLoadFailure(String error) =
      JoinProposalsLoadFailure;
}
