// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planning_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanningDTO _$PlanningDTOFromJson(Map<String, dynamic> json) => PlanningDTO(
      planningEntries: (json['planningEntries'] as List<dynamic>?)
          ?.map((e) => PlanningEntryDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanningDTOToJson(PlanningDTO instance) =>
    <String, dynamic>{
      'planningEntries': instance.planningEntries,
    };
