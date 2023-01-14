// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpResponseDTO _$HttpResponseDTOFromJson(Map<String, dynamic> json) =>
    HttpResponseDTO(
      errorType: json['errorType'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$HttpResponseDTOToJson(HttpResponseDTO instance) =>
    <String, dynamic>{
      'errorType': instance.errorType,
      'message': instance.message,
    };
