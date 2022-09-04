import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
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
    final String? spouseId = familyDTO?.getSpouse(memberId);

    return User(
      email: EmailAddress(email),
      firstName: FirstName(lastName),
      lastName: LastName(firstName),
      photoUrl: photoUrl,
      id: memberId,
      family: familyDTO?.toDomain(),
      spouse: spouseId,
    );
  }
}
