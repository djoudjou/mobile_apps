import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person_dto.g.dart';

@JsonSerializable()
class PersonDTO {
  String? personId;
  String? firstName;
  String? lastName;
  String? email;
  String? photoUrl;
  int? nbLogin;
  List<String>? tokens;

  PersonDTO({
    this.personId,
    this.firstName,
    this.lastName,
    this.email,
    this.photoUrl,
    this.nbLogin,
    this.tokens,
  });

  factory PersonDTO.fromUser(User user) => PersonDTO(
        email: user.email.getOrCrash(),
        firstName: user.surname.getOrCrash(),
        lastName: user.name.getOrCrash(),
        personId: user.id,
        photoUrl: user.photoUrl,
      );

  factory PersonDTO.fromJson(Map<String, dynamic> json) =>
      _$PersonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PersonDTOToJson(this);

  User toDomain(FamilyDTO? familyDTO) {
    final PersonDTO? spouse = (familyDTO != null && familyDTO.members != null)
        ? familyDTO.members
            ?.firstWhere((element) => element.personId != personId)
        : null;

    return User(
      email: EmailAddress(email),
      name: Name(lastName),
      surname: Surname(firstName),
      photoUrl: photoUrl,
      id: personId,
      family: familyDTO?.toDomain(),
      spouse: spouse?.personId,
    );
  }
}