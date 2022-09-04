// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyEventDTO _$FamilyEventDTOFromJson(Map<String, dynamic> json) =>
    FamilyEventDTO(
      id: json['id'] as String,
      creationDate: _$JsonConverterFromJson<String, DateTime>(
          json['creationDate'], const CustomDateTimeConverter().fromJson),
      message: json['message'] as String,
      args: (json['args'] as List<dynamic>).map((e) => e as String).toList(),
      memberId: json['memberId'] as String,
      read: json['read'] as bool,
      messageKey: json['messageKey'] as String,
    );

Map<String, dynamic> _$FamilyEventDTOToJson(FamilyEventDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': _$JsonConverterToJson<String, DateTime>(
          instance.creationDate, const CustomDateTimeConverter().toJson),
      'message': instance.message,
      'messageKey': instance.messageKey,
      'args': instance.args,
      'memberId': instance.memberId,
      'read': instance.read,
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
