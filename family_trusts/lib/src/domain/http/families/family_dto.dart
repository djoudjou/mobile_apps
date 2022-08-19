import 'dart:core';

import 'package:familytrusts/src/domain/http/persons/person_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_dto.g.dart';

@JsonSerializable()
class FamilyDTO {
  String? familyId;
  String? name;
  List<PersonDTO>? members;

  FamilyDTO({
    this.familyId,
    this.name,
    this.members,
  });

  factory FamilyDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyDTOToJson(this);
}
