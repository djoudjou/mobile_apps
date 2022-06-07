import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/infrastructure/invitation/invitation_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'spouse_proposal_entity.freezed.dart';

part 'spouse_proposal_entity.g.dart';

@freezed
abstract class SpouseProposalEntity implements _$SpouseProposalEntity {
  const SpouseProposalEntity._(); // Added constructor

  const factory SpouseProposalEntity({
    //@JsonKey(ignore: true)
    String? id,
    Map<String, dynamic>? spouseProposal,
  }) = _SpouseProposalEntity;

  factory SpouseProposalEntity.fromDomain(Invitation invitation) {
    return SpouseProposalEntity(
      spouseProposal: InvitationEntity.fromDomain(invitation).toJson(),
    );
  }

  factory SpouseProposalEntity.fromJson(Map<String, dynamic> json) =>
      _$SpouseProposalEntityFromJson(json);

  factory SpouseProposalEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>>doc) {
    return SpouseProposalEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
