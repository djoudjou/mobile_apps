import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/persons/person_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_dto.g.dart';

@JsonSerializable()
class MemberDTO {
  String? memberId;
  String? firstName;
  String? lastName;
  String? email;
  String? photoUrl;

  MemberDTO({
    this.memberId,
    this.firstName,
    this.lastName,
    this.email,
    this.photoUrl,
  });

  factory MemberDTO.fromJson(Map<String, dynamic> json) =>
      _$MemberDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MemberDTOToJson(this);

  User toDomain(FamilyDTO? familyDTO) {
    final PersonDTO? spouse = (familyDTO != null && familyDTO.members != null)
        ? familyDTO.members
            ?.firstWhere((element) => element.personId != memberId)
        : null;

    return User(
      email: EmailAddress(email),
      name: Name(lastName),
      surname: Surname(firstName),
      photoUrl: photoUrl,
      id: memberId,
      family: familyDTO?.toDomain(),
      spouse: spouse?.personId,
    );
  }
}
