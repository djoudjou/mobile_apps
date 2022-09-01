// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDTO _$LocationDTOFromJson(Map<String, dynamic> json) => LocationDTO(
      locationId: json['locationId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$LocationDTOToJson(LocationDTO instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'name': instance.name,
      'address': instance.address,
      'photoUrl': instance.photoUrl,
    };
