// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberDTO _$MemberDTOFromJson(Map<String, dynamic> json) => MemberDTO(
      memberId: json['memberId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$MemberDTOToJson(MemberDTO instance) => <String, dynamic>{
      'memberId': instance.memberId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
    };
