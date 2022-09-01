// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildDTO _$ChildDTOFromJson(Map<String, dynamic> json) => ChildDTO(
      childId: json['childId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$ChildDTOToJson(ChildDTO instance) => <String, dynamic>{
      'childId': instance.childId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday,
      'photoUrl': instance.photoUrl,
    };
