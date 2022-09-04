// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_trust_person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTrustPersonDTO _$UpdateTrustPersonDTOFromJson(
        Map<String, dynamic> json) =>
    UpdateTrustPersonDTO(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UpdateTrustPersonDTOToJson(
        UpdateTrustPersonDTO instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
    };
