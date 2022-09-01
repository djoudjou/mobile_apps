import 'dart:core';

import 'package:familytrusts/src/infrastructure/http/family_event/family_event_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_events_dto.g.dart';

@JsonSerializable()
class FamilyEventsDTO {
  List<FamilyEventDTO>? events;
  int? nbNotSeen;

  FamilyEventsDTO({
    this.events,
    this.nbNotSeen,
  });

  factory FamilyEventsDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyEventsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyEventsDTOToJson(this);
}
