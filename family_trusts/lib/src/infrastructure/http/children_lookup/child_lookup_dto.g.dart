// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_lookup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildLookupDTO _$ChildLookupDTOFromJson(Map<String, dynamic> json) =>
    ChildLookupDTO(
      childLookupId: json['childLookupId'] as String?,
      issuer: json['issuer'] == null
          ? null
          : MemberDTO.fromJson(json['issuer'] as Map<String, dynamic>),
      acceptedTrustPerson: json['acceptedTrustPerson'] == null
          ? null
          : TrustPersonDTO.fromJson(
              json['acceptedTrustPerson'] as Map<String, dynamic>),
      familyName: json['familyName'] as String?,
      child: json['child'] == null
          ? null
          : ChildDTO.fromJson(json['child'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : LocationDTO.fromJson(json['location'] as Map<String, dynamic>),
      expectedDate: _$JsonConverterFromJson<String, DateTime>(
          json['expectedDate'], const CustomDateTimeConverter().fromJson),
      expirationDate: _$JsonConverterFromJson<String, DateTime>(
          json['expirationDate'], const CustomDateTimeConverter().fromJson),
      trustedPersons: (json['trustedPersons'] as List<dynamic>?)
          ?.map((e) => TrustPersonDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ChildLookupDTOToJson(ChildLookupDTO instance) =>
    <String, dynamic>{
      'childLookupId': instance.childLookupId,
      'issuer': instance.issuer,
      'acceptedTrustPerson': instance.acceptedTrustPerson,
      'familyName': instance.familyName,
      'child': instance.child,
      'location': instance.location,
      'expectedDate': _$JsonConverterToJson<String, DateTime>(
          instance.expectedDate, const CustomDateTimeConverter().toJson),
      'expirationDate': _$JsonConverterToJson<String, DateTime>(
          instance.expirationDate, const CustomDateTimeConverter().toJson),
      'trustedPersons': instance.trustedPersons,
      'status': instance.status,
      'reason': instance.reason,
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
