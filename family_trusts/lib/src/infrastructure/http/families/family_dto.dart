import 'dart:core';

import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/member_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family_dto.g.dart';

@JsonSerializable()
class FamilyDTO {
  String? familyId;
  String? name;
  List<MemberDTO>? members;

  FamilyDTO({
    this.familyId,
    this.name,
    this.members,
  });

  factory FamilyDTO.fromJson(Map<String, dynamic> json) =>
      _$FamilyDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyDTOToJson(this);

  Family toDomain() {
    return Family(
      name: FirstName(name),
      id: familyId,
    );
  }

  String? getSpouse(String? personId) {
    return members != null && members!.length>1 && personId != null
        ? members!
            .firstWhere((element) => element.memberId != personId)
            .memberId
        : null;
  }
}
