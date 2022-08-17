
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'login_person_dto.g.dart';

@JsonSerializable()
class LoginPersonDTO {
  String? token;

  LoginPersonDTO({this.token});

  factory LoginPersonDTO.fromJson(Map<String, dynamic> json) => _$LoginPersonDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPersonDTOToJson(this);
}