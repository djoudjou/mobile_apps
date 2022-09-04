// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_child_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChildDTO _$UpdateChildDTOFromJson(Map<String, dynamic> json) =>
    UpdateChildDTO(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UpdateChildDTOToJson(UpdateChildDTO instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthday': instance.birthday,
      'photoUrl': instance.photoUrl,
    };
