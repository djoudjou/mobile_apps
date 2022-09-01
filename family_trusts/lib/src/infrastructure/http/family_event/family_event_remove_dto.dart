import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'family_event_remove_dto.g.dart';

@JsonSerializable()
class FamilyEventRemoveDTO {
  String issuerId;

  FamilyEventRemoveDTO({
    required this.issuerId,
  });

  factory FamilyEventRemoveDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyEventRemoveDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyEventRemoveDTOToJson(this);
}
