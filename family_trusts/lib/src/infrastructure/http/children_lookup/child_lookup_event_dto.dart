import 'dart:core';

import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_lookup_event_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class ChildLookupEventDTO {
  DateTime? creationDate;
  String? message;

  ChildLookupEventDTO({
    this.creationDate,
    this.message,
  });

  factory ChildLookupEventDTO.fromJson(Map<String, dynamic> json) =>
      _$ChildLookupEventDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChildLookupEventDTOToJson(this);

  ChildrenLookupHistory toDomain(FamilyDTO familyDTO) {
    return ChildrenLookupHistory(
      creationDate:
          TimestampVo.fromTimestamp(creationDate!.millisecondsSinceEpoch),
      message: message!,
    );
  }
}
