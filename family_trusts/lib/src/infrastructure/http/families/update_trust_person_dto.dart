import 'dart:core';

import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_trust_person_dto.g.dart';

@JsonSerializable()
class UpdateTrustPersonDTO {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? photoUrl;
  String? email;

  UpdateTrustPersonDTO({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
  });

  factory UpdateTrustPersonDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateTrustPersonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTrustPersonDTOToJson(this);

  factory UpdateTrustPersonDTO.fromTrustedPerson(TrustedUser trustedUser) =>
      UpdateTrustPersonDTO(
        firstName: trustedUser.firstName.getOrCrash(),
        lastName: trustedUser.lastName.getOrCrash(),
        photoUrl: trustedUser.photoUrl,
        email: trustedUser.email.getOrCrash(),
        phoneNumber: trustedUser.phoneNumber.getOrCrash(),
      );
}
