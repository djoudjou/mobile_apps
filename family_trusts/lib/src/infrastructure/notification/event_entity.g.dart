// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventEntity _$_$_EventEntityFromJson(Map<String, dynamic> json) {
  return _$_EventEntity(
    id: json['id'] as String?,
    date: json['date'] as int,
    from: json['from'] as String,
    to: json['to'] as String,
    type: json['type'] as String,
    seen: json['seen'] as bool,
    subject: json['subject'] as String?,
  );
}

Map<String, dynamic> _$_$_EventEntityToJson(_$_EventEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'from': instance.from,
      'to': instance.to,
      'type': instance.type,
      'seen': instance.seen,
      'subject': instance.subject,
    };
