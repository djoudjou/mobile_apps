import 'dart:core';

import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/planning_entry_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'planning_dto.g.dart';

@JsonSerializable()
class PlanningDTO {
  List<PlanningEntryDTO>? planningEntries;

  PlanningDTO({
    this.planningEntries,
  });

  factory PlanningDTO.fromJson(Map<String, dynamic> json) =>
      _$PlanningDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PlanningDTOToJson(this);

  Planning toDomain(FamilyDTO familyDTO) {
    return Planning(
      entries: planningEntries!.map((e) => e.toDomain(familyDTO)).toList(),
    );
  }
}
