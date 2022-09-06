import 'dart:core';

import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_child_lookup_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class CreateChildLookupDTO {
  String issuerId;
  String childId;
  String locationId;
  DateTime expectedDate;

  CreateChildLookupDTO({
    required this.issuerId,
    required this.childId,
    required this.locationId,
    required this.expectedDate,

  });

  factory CreateChildLookupDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateChildLookupDTOFromJson(json);

  factory CreateChildLookupDTO.from(ChildrenLookup childrenLookup) {
    return CreateChildLookupDTO(
      issuerId: childrenLookup.issuer!.id!,
      childId:  childrenLookup.child!.id!,
      locationId: childrenLookup.location!.id!,
      expectedDate: childrenLookup.rendezVous.getOrCrash(),
    );
  }

  Map<String, dynamic> toJson() => _$CreateChildLookupDTOToJson(this);


}
