import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
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


}
