import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'invitation_entity.freezed.dart';

part 'invitation_entity.g.dart';


@freezed
class InvitationEntity with _$InvitationEntity {
  const InvitationEntity._(); // Added constructor

  const factory InvitationEntity({
    required int date,
    required String from,
    required String to,
    required String type,
  }) = _InvitationEntity;

  factory InvitationEntity.fromDomain(Invitation invitation) {
    return InvitationEntity(
      date: invitation.date.getOrCrash(),
      from: invitation.from.id!,
      to: invitation.to.id!,
      type: invitation.type.toText,
    );
  }

  factory InvitationEntity.fromJson(Map<String, dynamic> json) =>
      _$InvitationEntityFromJson(json);

  factory InvitationEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>>doc) {
    return InvitationEntity.fromJson(doc.data()!);
  }
}
