import 'dart:core';

import 'package:familytrusts/src/domain/family/child.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_child_dto.g.dart';

@JsonSerializable()
class UpdateChildDTO {
  String? firstName;
  String? lastName;
  String? birthday;
  String? photoUrl;

  UpdateChildDTO({
    this.firstName,
    this.lastName,
    this.birthday,
    this.photoUrl,
  });

  factory UpdateChildDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateChildDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateChildDTOToJson(this);

  factory UpdateChildDTO.fromChild(Child child) {
    return UpdateChildDTO(
      firstName: child.firstName.getOrCrash(),
      lastName: child.lastName.getOrCrash(),
      birthday: child.birthday.toText,
      photoUrl: child.photoUrl,
    );
  }
}
