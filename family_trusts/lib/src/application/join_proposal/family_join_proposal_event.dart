import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_join_proposal_event.freezed.dart';

@freezed
abstract class FamilyJoinProposalEvent with _$FamilyJoinProposalEvent {
  const factory FamilyJoinProposalEvent.loadProposals({
    required Family? family,
  }) = FamilyLoadProposals;

  const factory FamilyJoinProposalEvent.accept({
    required User connectedUser,
    required JoinProposal joinProposal,
  }) = Accept;

  const factory FamilyJoinProposalEvent.decline({
    required User connectedUser,
    required JoinProposal joinProposal,
  }) = Decline;
}
