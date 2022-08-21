import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_proposal_event.freezed.dart';

@freezed
abstract class JoinProposalEvent with _$JoinProposalEvent {
  const factory JoinProposalEvent.loadProposals({
    required User connectedUser,
  }) = LoadProposals;
  const factory JoinProposalEvent.send({
    required User connectedUser,
    required Family family,
  }) = Send;

  const factory JoinProposalEvent.cancel({
    required User connectedUser,
    required JoinProposal joinProposal,
  }) = Cancel;
}
