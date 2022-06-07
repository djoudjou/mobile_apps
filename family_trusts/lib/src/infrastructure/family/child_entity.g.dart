// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChildEntity _$_$_ChildEntityFromJson(Map<String, dynamic> json) {
  return _$_ChildEntity(
    id: json['id'] as String?,
    name: json['name'] as String,
    surname: json['surname'] as String,
    birthday: json['birthday'] as String,
    photoUrl: json['photoUrl'] as String?,
  );
}

Map<String, dynamic> _$_$_ChildEntityToJson(_$_ChildEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'birthday': instance.birthday,
      'photoUrl': instance.photoUrl,
    };
