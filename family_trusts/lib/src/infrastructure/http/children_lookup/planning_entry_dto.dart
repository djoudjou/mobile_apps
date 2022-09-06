import 'dart:core';

import 'package:familytrusts/src/domain/planning/planning_entry.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_dto.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'planning_entry_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class PlanningEntryDTO {
  DateTime? day;
  List<ChildLookupDTO>? childLookups;

  PlanningEntryDTO({
    this.day,
    this.childLookups,
  });

  factory PlanningEntryDTO.fromJson(Map<String, dynamic> json) =>
      _$PlanningEntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PlanningEntryDTOToJson(this);

  PlanningEntry toDomain(FamilyDTO familyDTO) {
    return PlanningEntry(
      day: day!,
      childrenLookups: childLookups!.map((e) => e.toDomain(familyDTO)).toList(),
    );
  }
}
