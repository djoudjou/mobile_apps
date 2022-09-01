import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'issuer_join_proposal_event.freezed.dart';

@freezed
abstract class IssuerJoinProposalEvent with _$IssuerJoinProposalEvent {
  const factory IssuerJoinProposalEvent.loadProposals({
    required User connectedUser,
  }) = LoadProposals;
  const factory IssuerJoinProposalEvent.send({
    required User connectedUser,
    required Family family,
  }) = Send;

  const factory IssuerJoinProposalEvent.cancel({
    required User connectedUser,
    required JoinProposal joinProposal,
  }) = Cancel;
}
