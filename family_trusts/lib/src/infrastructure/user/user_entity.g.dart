// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map<String, dynamic> json) =>
    _$_UserEntity(
      id: json['id'] as String?,
      familyId: json['familyId'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      photoUrl: json['photoUrl'] as String?,
      spouse: json['spouse'] as String?,
    );

Map<String, dynamic> _$$_UserEntityToJson(_$_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'photoUrl': instance.photoUrl,
      'spouse': instance.spouse,
    };
