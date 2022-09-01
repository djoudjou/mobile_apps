import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'create_child_lookup_dto.g.dart';

@JsonSerializable()
class CreateChildLookupDTO {
  String? issuerId;
  String? childId;
  String? locationId;

  CreateChildLookupDTO({
    this.issuerId,
    this.childId,
    this.locationId,
  });

  factory CreateChildLookupDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateChildLookupDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChildLookupDTOToJson(this);
}
