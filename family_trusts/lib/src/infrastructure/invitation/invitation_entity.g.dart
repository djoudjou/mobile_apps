// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InvitationEntity _$$_InvitationEntityFromJson(Map<String, dynamic> json) =>
    _$_InvitationEntity(
      date: json['date'] as int,
      from: json['from'] as String,
      to: json['to'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_InvitationEntityToJson(_$_InvitationEntity instance) =>
    <String, dynamic>{
      'date': instance.date,
      'from': instance.from,
      'to': instance.to,
      'type': instance.type,
    };
