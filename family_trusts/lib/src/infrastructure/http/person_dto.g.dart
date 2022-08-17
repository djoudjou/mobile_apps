// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDTO _$PersonDTOFromJson(Map<String, dynamic> json) => PersonDTO(
      personId: json['personId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      nbLogin: json['nbLogin'] as int?,
      tokens:
          (json['tokens'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PersonDTOToJson(PersonDTO instance) => <String, dynamic>{
      'personId': instance.personId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'nbLogin': instance.nbLogin,
      'tokens': instance.tokens,
    };
