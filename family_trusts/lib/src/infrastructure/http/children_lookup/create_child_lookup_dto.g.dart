// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_child_lookup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChildLookupDTO _$CreateChildLookupDTOFromJson(
        Map<String, dynamic> json) =>
    CreateChildLookupDTO(
      issuerId: json['issuerId'] as String,
      childId: json['childId'] as String,
      locationId: json['locationId'] as String,
      expectedDate: const CustomDateTimeConverter()
          .fromJson(json['expectedDate'] as String),
    );

Map<String, dynamic> _$CreateChildLookupDTOToJson(
        CreateChildLookupDTO instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'childId': instance.childId,
      'locationId': instance.locationId,
      'expectedDate':
          const CustomDateTimeConverter().toJson(instance.expectedDate),
    };
