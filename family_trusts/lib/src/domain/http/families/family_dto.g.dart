// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyDTO _$FamilyDTOFromJson(Map<String, dynamic> json) => FamilyDTO(
      familyId: json['familyId'] as String?,
      name: json['name'] as String?,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => PersonDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FamilyDTOToJson(FamilyDTO instance) => <String, dynamic>{
      'familyId': instance.familyId,
      'name': instance.name,
      'members': instance.members,
    };
