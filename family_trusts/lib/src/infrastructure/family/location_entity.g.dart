// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocationEntity _$_$_LocationEntityFromJson(Map<String, dynamic> json) {
  return _$_LocationEntity(
    id: json['id'] as String?,
    title: json['title'] as String,
    address: json['address'] as String,
    note: json['note'] as String,
    photoUrl: json['photoUrl'] as String?,
  );
}

Map<String, dynamic> _$_$_LocationEntityToJson(_$_LocationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'note': instance.note,
      'photoUrl': instance.photoUrl,
    };
