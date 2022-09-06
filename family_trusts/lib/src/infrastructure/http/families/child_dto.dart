import 'dart:core';

import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_dto.g.dart';

@JsonSerializable()
class ChildDTO {
  String? childId;
  String? firstName;
  String? lastName;
  String? birthday;
  String? photoUrl;

  ChildDTO({
    this.childId,
    this.firstName,
    this.lastName,
    this.birthday,
    this.photoUrl,
  });

  factory ChildDTO.fromJson(Map<String, dynamic> json) =>
      _$ChildDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChildDTOToJson(this);

  Child toDomain() {
    return Child(
      firstName: FirstName(firstName),
      id: childId,
      birthday: Birthday.fromValue(birthday),
      lastName: LastName(lastName),
    );
  }
}
