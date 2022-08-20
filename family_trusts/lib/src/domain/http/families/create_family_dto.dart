import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'create_family_dto.g.dart';

@JsonSerializable()
class CreateFamilyDTO {
  String? name;
  String? memberId;

  CreateFamilyDTO({
    this.name,
    this.memberId,
  });

  factory CreateFamilyDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateFamilyDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFamilyDTOToJson(this);
}
