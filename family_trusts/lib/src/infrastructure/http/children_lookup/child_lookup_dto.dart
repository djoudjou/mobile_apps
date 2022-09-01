import 'dart:core';

import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/trust_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/member_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'child_dto.dart';

part 'child_lookup_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class ChildLookupDTO {
  String? childLookupId;
  MemberDTO? issuer;
  TrustPersonDTO? acceptedTrustPerson;
  String? familyName;
  ChildDTO? child;
  LocationDTO? location;
  DateTime? expectedDate;
  DateTime? expirationDate;
  List<TrustPersonDTO>? trustedPersons;
  String? status;
  String? reason;

  ChildLookupDTO({
    this.childLookupId,
    this.issuer,
    this.acceptedTrustPerson,
    this.familyName,
    this.child,
    this.location,
    this.expectedDate,
    this.expirationDate,
    this.trustedPersons,
    this.status,
    this.reason,
  });

  factory ChildLookupDTO.fromJson(Map<String, dynamic> json) =>
      _$ChildLookupDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChildLookupDTOToJson(this);

  ChildrenLookup toDomain(FamilyDTO familyDTO) {
    // TODO ADJ missing Note & CreationDate on backend
    return ChildrenLookup(
      id: childLookupId,
      issuer: issuer?.toDomain(familyDTO),
      personInCharge: acceptedTrustPerson?.toDomain(),
      child: child?.toDomain(familyDTO),
      location: location?.toDomain(),
      state: MissionState.fromValue(status!),
      //creationDate: TimestampVo.fromTimestamp(lastUpdateDate!.millisecondsSinceEpoch),
      creationDate: TimestampVo.now(),
      noteBody: NoteBody(""),
      rendezVous: RendezVous.fromDate(expectedDate!),
    );
  }
}
