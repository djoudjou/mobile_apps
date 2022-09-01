import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'registred_person_response_dto.g.dart';

@JsonSerializable()
class RegisterPersonResponseDTO {
  String? personId;

  RegisterPersonResponseDTO({this.personId});

  factory RegisterPersonResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$RegisterPersonResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPersonResponseDTOToJson(this);
}
