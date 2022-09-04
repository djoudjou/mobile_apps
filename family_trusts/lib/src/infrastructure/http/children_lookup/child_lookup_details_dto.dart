import 'dart:core';

import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_details.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_event_dto.dart';
import 'package:familytrusts/src/infrastructure/http/custom_datetime_converter.dart';
import 'package:familytrusts/src/infrastructure/http/families/child_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/trust_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/member_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_lookup_details_dto.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class ChildLookupDetailsDTO {
  String? childLookupId;
  MemberDTO? issuer;
  TrustPersonDTO? acceptedTrustPerson;
  String? familyName;
  ChildDTO? child;
  LocationDTO? location;
  DateTime? expectedDate;
  DateTime? expirationDate;
  List<TrustPersonDTO>? trustedPersons;
  List<ChildLookupEventDTO>? events;
  String? status;
  String? reason;

  ChildLookupDetailsDTO({
    this.childLookupId,
    this.issuer,
    this.acceptedTrustPerson,
    this.familyName,
    this.child,
    this.location,
    this.expectedDate,
    this.expirationDate,
    this.trustedPersons,
    this.events,
    this.status,
    this.reason,
  });

  factory ChildLookupDetailsDTO.fromJson(Map<String, dynamic> json) =>
      _$ChildLookupDetailsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChildLookupDetailsDTOToJson(this);

  ChildrenLookupDetails toDomain(FamilyDTO familyDTO) {
    // TODO ADJ missing Note & CreationDate on backend

    List<ChildrenLookupHistory> histories = [];
    if (events != null) {
      histories = events!.map((e) => e.toDomain(familyDTO)).toList();
    }

    return ChildrenLookupDetails(
      childrenLookup: ChildrenLookup(
        id: childLookupId,
        issuer: issuer?.toDomain(familyDTO),
        personInCharge: acceptedTrustPerson?.toDomain(),
        child: child?.toDomain(),
        location: location?.toDomain(),
        state: MissionState.fromValue(status!),
        //creationDate: TimestampVo.fromTimestamp(lastUpdateDate!.millisecondsSinceEpoch),
        creationDate: TimestampVo.now(),
        noteBody: NoteBody(""),
        rendezVous: RendezVous.fromDate(expectedDate!),
      ),
      histories: histories,
    );
  }
}
