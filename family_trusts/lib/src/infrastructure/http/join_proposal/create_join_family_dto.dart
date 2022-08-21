import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'create_join_family_dto.g.dart';

@JsonSerializable()
class CreateJoinFamilyProposalDTO {
  String issuerId;
  String familyId;

  CreateJoinFamilyProposalDTO({
    required this.issuerId,
    required this.familyId,
  });

  factory CreateJoinFamilyProposalDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateJoinFamilyProposalDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateJoinFamilyProposalDTOToJson(this);
}
