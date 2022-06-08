import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_entity.freezed.dart';

/*
id: json['id'] as String?,
    creationDate: json['creationDate'] as int,
    familyId: json['familyId'] as String?,
    childId: json['childId'] as String?,
    locationId: json['locationId'] as String?,
    rendezVous: DateTime.parse(json['rendezVous'] as String),
    state: json['state'] as String,
    issuerId: json['issuerId'] as String?,
    personInChargeId: json['personInChargeId'] as String?,
    notes: json['notes'] as String,
    trustedUsers: (json['trustedUsers'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$_$_ChildrenLookupEntityToJson(
        _$_ChildrenLookupEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'familyId': instance.familyId,
      'childId': instance.childId,
      'locationId': instance.locationId,
      'rendezVous': instance.rendezVous.toIso8601String(),
      'state': instance.state,
      'issuerId': instance.issuerId,
      'personInChargeId': instance.personInChargeId,
      'notes': instance.notes,
      'trustedUsers': instance.trustedUsers,
    };
 */

@freezed
class ChildrenLookupEntity with _$ChildrenLookupEntity {
  const ChildrenLookupEntity._(); // Added constructor

  const factory ChildrenLookupEntity({
    String? id,
    required int creationDate,
    String? familyId,
    String? childId,
    String? locationId,
    required DateTime rendezVous,
    required String state,
    String? issuerId,
    String? personInChargeId,
    required String notes,
    required List<String> trustedUsers,
  }) = _ChildrenLookupEntity;

  factory ChildrenLookupEntity.fromDomain(ChildrenLookup domain) {
    return ChildrenLookupEntity(
      id: domain.id,
      familyId: domain.issuer?.familyId,
      creationDate: domain.creationDate.getOrCrash(),
      childId: domain.child!.id,
      locationId: domain.location!.id,
      rendezVous: domain.rendezVous.getOrCrash(),
      state: domain.state!.toText,
      issuerId: domain.issuer?.id,
      notes: domain.noteBody.getOrCrash(),
      trustedUsers: domain.trustedUsers,
      personInChargeId: domain.personInCharge?.id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'creationDate': creationDate,
      'familyId': familyId,
      'childId': childId,
      'locationId': locationId,
      'rendezVous': Timestamp.fromDate(rendezVous),
      'state': state,
      'issuerId': issuerId,
      'personInChargeId': personInChargeId,
      'notes': notes,
      'trustedUsers': trustedUsers,
    };
  }

  factory ChildrenLookupEntity.fromJson(Map<String, dynamic> json) {
    return ChildrenLookupEntity(
      id: json['id'] as String?,
      creationDate: json['creationDate'] as int,
      familyId: json['familyId'] as String?,
      childId: json['childId'] as String?,
      locationId: json['locationId'] as String?,
      rendezVous: (json['rendezVous'] as Timestamp).toDate(),
      state: json['state'] as String,
      issuerId: json['issuerId'] as String?,
      personInChargeId: json['personInChargeId'] as String?,
      notes: json['notes'] as String,
      trustedUsers: (json['trustedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  factory ChildrenLookupEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return ChildrenLookupEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }

/*
  factory ChildrenLookupEntity.fromJson(Map<String, dynamic> json) =>
      _$ChildrenLookupEntityFromJson(json);

  factory ChildrenLookupEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChildrenLookupEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
  */
}
