import 'dart:core';

import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_lookup_event_dto.g.dart';

@JsonSerializable()
class ChildLookupEventDTO {
  String? date_text;
  String? message;

  ChildLookupEventDTO({
    this.date_text,
    this.message,
  });

  factory ChildLookupEventDTO.fromJson(Map<String, dynamic> json) =>
      _$ChildLookupEventDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChildLookupEventDTOToJson(this);

  ChildrenLookupHistory toDomain(FamilyDTO familyDTO) {
    // TODO ADJ missing id
    return ChildrenLookupHistory(
      id: "",
      creationDate: date_text!,
      message: message!,
    );
  }
}
