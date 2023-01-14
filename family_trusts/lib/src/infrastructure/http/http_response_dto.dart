import 'dart:core';

import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'http_response_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class HttpResponseDTO {
  String? errorType;
  String? message;

  HttpResponseDTO({this.errorType, this.message});

  factory HttpResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$HttpResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$HttpResponseDTOToJson(this);
}
