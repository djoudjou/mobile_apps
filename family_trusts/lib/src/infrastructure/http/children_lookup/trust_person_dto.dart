import 'dart:core';

import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trust_person_dto.g.dart';

@JsonSerializable()
class TrustPersonDTO {
  String? trustPersonId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? photoUrl;

  TrustPersonDTO({
    this.trustPersonId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
  });

  factory TrustPersonDTO.fromJson(Map<String, dynamic> json) =>
      _$TrustPersonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TrustPersonDTOToJson(this);

  User toDomain() {
    return User(
      name: Name(lastName),
      surname: Surname(firstName),
      email: EmailAddress(email),
      photoUrl: photoUrl,
    );
  }
}
