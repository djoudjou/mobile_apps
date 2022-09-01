import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'issuer_join_proposal_state.freezed.dart';

@freezed
class IssuerJoinProposalState with _$IssuerJoinProposalState {
  const factory IssuerJoinProposalState.initial() = Initial;

  const factory IssuerJoinProposalState.joinProposalSendInProgress() =
      JoinProposalSendInProgress;

  const factory IssuerJoinProposalState.joinProposalSendSuccess() =
      JoinProposalSendSuccess;

  const factory IssuerJoinProposalState.joinProposalSendFailure(String error) =
      JoinProposalSendFailure;

  const factory IssuerJoinProposalState.joinProposalCancelInProgress() =
      JoinProposalCancelInProgress;

  const factory IssuerJoinProposalState.joinProposalCancelSuccess() =
      JoinProposalCancelSuccess;

  const factory IssuerJoinProposalState.joinProposalCancelFailure(String error) =
      JoinProposalCancelFailure;

  const factory IssuerJoinProposalState.joinProposalsLoadInProgress() =
      JoinProposalsLoadInProgress;

  const factory IssuerJoinProposalState.joinProposalsLoaded({
    required bool hasPendingProposals,
    required Option<JoinProposal> optionPendingJoinProposal,
    required List<JoinProposal> archives,
  }) = JoinProposalsLoaded;

  const factory IssuerJoinProposalState.joinProposalsLoadFailure(String error) =
      JoinProposalsLoadFailure;
}
