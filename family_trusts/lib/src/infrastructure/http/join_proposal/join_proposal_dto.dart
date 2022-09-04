import 'dart:core';

import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/member_dto.dart';
import 'package:familytrusts/src/infrastructure/http/persons/person_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'join_proposal_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class JoinFamilyProposalDTO {
  String? joinFamilyProposalId;
  String? familyName;
  PersonDTO? issuer;
  MemberDTO? member;
  String? reason;
  String? status;
  DateTime? creationDate;
  DateTime? lastUpdateDate;
  DateTime? expirationDate;

  JoinFamilyProposalDTO({
    this.joinFamilyProposalId,
    this.familyName,
    this.issuer,
    this.member,
    this.reason,
    this.status,
    this.creationDate,
    this.lastUpdateDate,
    this.expirationDate,
  });

  factory JoinFamilyProposalDTO.fromJson(Map<String, dynamic> json) =>
      _$JoinFamilyProposalDTOFromJson(json);

  Map<String, dynamic> toJson() => _$JoinFamilyProposalDTOToJson(this);

  JoinProposal toDomain() {
    return JoinProposal(
      id: joinFamilyProposalId,
      creationDate:
          TimestampVo.fromTimestamp(creationDate!.millisecondsSinceEpoch),
      expirationDate:
          TimestampVo.fromTimestamp(expirationDate!.millisecondsSinceEpoch),
      lastUpdateDate:
          TimestampVo.fromTimestamp(lastUpdateDate!.millisecondsSinceEpoch),
      family: Family(name: FirstName(familyName)),
      issuer: issuer!.toDomain(null),
      member: member?.toDomain(null),
      state: JoinProposalStatus.fromValue(status!),
    );
  }
}
