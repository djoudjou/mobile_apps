import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'family_event_mark_as_read_dto.g.dart';

@JsonSerializable()
class FamilyEventMarkAsReadDTO {
  String issuerId;

  FamilyEventMarkAsReadDTO({
    required this.issuerId,
  });

  factory FamilyEventMarkAsReadDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyEventMarkAsReadDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyEventMarkAsReadDTOToJson(this);
}
