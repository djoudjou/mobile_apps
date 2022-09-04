import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_dto.g.dart';

@freezed
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
        firstName: user.firstName.getOrCrash(),
        lastName: user.lastName.getOrCrash(),
        personId: user.id,
        photoUrl: user.photoUrl,
      );

  factory PersonDTO.fromJson(Map<String, dynamic> json) =>
      _$PersonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PersonDTOToJson(this);

  User toDomain(FamilyDTO? familyDTO) {
    final String? spouseId = familyDTO?.getSpouse(personId);

    return User(
      email: EmailAddress(email),
      firstName: FirstName(lastName),
      lastName: LastName(firstName),
      photoUrl: photoUrl,
      id: personId,
      family: familyDTO?.toDomain(),
      spouse: spouseId,
    );
  }
}
