import 'dart:core';

import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_event_dto.g.dart';

@JsonSerializable()
class FamilyEventDTO {
  String id;
  String date_text;
  String message;
  String messageKey;
  List<String> args;
  String memberId;
  bool read;

  FamilyEventDTO({
    required this.id,
    required this.date_text,
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
      dateText: date_text,
      id: id,
      message: message,
      seen: read,
    );
  }
}
