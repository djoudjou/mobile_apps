// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planning_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanningEntryDTO _$PlanningEntryDTOFromJson(Map<String, dynamic> json) =>
    PlanningEntryDTO(
      day: _$JsonConverterFromJson<String, DateTime>(
          json['day'], const CustomDateTimeConverter().fromJson),
      childLookups: (json['childLookups'] as List<dynamic>?)
          ?.map((e) => ChildLookupDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanningEntryDTOToJson(PlanningEntryDTO instance) =>
    <String, dynamic>{
      'day': _$JsonConverterToJson<String, DateTime>(
          instance.day, const CustomDateTimeConverter().toJson),
      'childLookups': instance.childLookups,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
