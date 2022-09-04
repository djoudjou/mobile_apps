// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLocationDTO _$UpdateLocationDTOFromJson(Map<String, dynamic> json) =>
    UpdateLocationDTO(
      name: json['name'] as String?,
      address: json['address'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UpdateLocationDTOToJson(UpdateLocationDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'photoUrl': instance.photoUrl,
    };
