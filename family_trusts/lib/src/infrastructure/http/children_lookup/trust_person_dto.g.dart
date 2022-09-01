// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trust_person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustPersonDTO _$TrustPersonDTOFromJson(Map<String, dynamic> json) =>
    TrustPersonDTO(
      trustPersonId: json['trustPersonId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$TrustPersonDTOToJson(TrustPersonDTO instance) =>
    <String, dynamic>{
      'trustPersonId': instance.trustPersonId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
    };
