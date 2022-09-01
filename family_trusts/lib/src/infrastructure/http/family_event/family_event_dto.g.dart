// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyEventDTO _$FamilyEventDTOFromJson(Map<String, dynamic> json) =>
    FamilyEventDTO(
      id: json['id'] as String,
      date_text: json['date_text'] as String,
      message: json['message'] as String,
      args: (json['args'] as List<dynamic>).map((e) => e as String).toList(),
      memberId: json['memberId'] as String,
      read: json['read'] as bool,
      messageKey: json['messageKey'] as String,
    );

Map<String, dynamic> _$FamilyEventDTOToJson(FamilyEventDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_text': instance.date_text,
      'message': instance.message,
      'messageKey': instance.messageKey,
      'args': instance.args,
      'memberId': instance.memberId,
      'read': instance.read,
    };
