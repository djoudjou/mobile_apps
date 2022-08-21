// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_proposal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinFamilyProposalDTO _$JoinFamilyProposalDTOFromJson(
        Map<String, dynamic> json) =>
    JoinFamilyProposalDTO(
      joinFamilyProposalId: json['joinFamilyProposalId'] as String?,
      familyName: json['familyName'] as String?,
      issuer: json['issuer'] == null
          ? null
          : PersonDTO.fromJson(json['issuer'] as Map<String, dynamic>),
      member: json['member'] == null
          ? null
          : MemberDTO.fromJson(json['member'] as Map<String, dynamic>),
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      creationDate: _$JsonConverterFromJson<String, DateTime>(
          json['creationDate'], const CustomDateTimeConverter().fromJson),
      lastUpdateDate: _$JsonConverterFromJson<String, DateTime>(
          json['lastUpdateDate'], const CustomDateTimeConverter().fromJson),
      expirationDate: _$JsonConverterFromJson<String, DateTime>(
          json['expirationDate'], const CustomDateTimeConverter().fromJson),
    );

Map<String, dynamic> _$JoinFamilyProposalDTOToJson(
        JoinFamilyProposalDTO instance) =>
    <String, dynamic>{
      'joinFamilyProposalId': instance.joinFamilyProposalId,
      'familyName': instance.familyName,
      'issuer': instance.issuer,
      'member': instance.member,
      'reason': instance.reason,
      'status': instance.status,
      'creationDate': _$JsonConverterToJson<String, DateTime>(
          instance.creationDate, const CustomDateTimeConverter().toJson),
      'lastUpdateDate': _$JsonConverterToJson<String, DateTime>(
          instance.lastUpdateDate, const CustomDateTimeConverter().toJson),
      'expirationDate': _$JsonConverterToJson<String, DateTime>(
          instance.expirationDate, const CustomDateTimeConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
