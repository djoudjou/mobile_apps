import 'dart:core';

import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_event_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class FamilyEventDTO {
  String id;
  DateTime? creationDate;
  String message;
  String messageKey;
  List<String> args;
  String memberId;
  bool read;

  FamilyEventDTO({
    required this.id,
    this.creationDate,
    required this.message,
    required this.args,
    required this.memberId,
    required this.read,
    required this.messageKey,
  });

  factory FamilyEventDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyEventDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyEventDTOToJson(this);

  Event toDomain() {
    return Event(
      creationDate:
          TimestampVo.fromTimestamp(creationDate!.millisecondsSinceEpoch),
      id: id,
      message: message,
      seen: read,
    );
  }
}
