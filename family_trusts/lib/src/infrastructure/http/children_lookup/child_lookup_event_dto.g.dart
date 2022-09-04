// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_lookup_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildLookupEventDTO _$ChildLookupEventDTOFromJson(Map<String, dynamic> json) =>
    ChildLookupEventDTO(
      creationDate: _$JsonConverterFromJson<String, DateTime>(
          json['creationDate'], const CustomDateTimeConverter().fromJson),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ChildLookupEventDTOToJson(
        ChildLookupEventDTO instance) =>
    <String, dynamic>{
      'creationDate': _$JsonConverterToJson<String, DateTime>(
          instance.creationDate, const CustomDateTimeConverter().toJson),
      'message': instance.message,
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
