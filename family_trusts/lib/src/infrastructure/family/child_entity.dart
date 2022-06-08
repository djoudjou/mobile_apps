import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_entity.freezed.dart';
part 'child_entity.g.dart';

@freezed
class ChildEntity with _$ChildEntity {
  const ChildEntity._(); // Added constructor
  const factory ChildEntity({
    //@JsonKey(ignore: true)
    String? id,
    required String name,
    required String surname,
    required String birthday,
    String? photoUrl,
  }) = _ChildEntity;

  factory ChildEntity.fromDomain(Child child) {
    return ChildEntity(
      id: child.id,
      name: child.name.getOrCrash(),
      surname: child.surname.getOrCrash(),
      birthday: child.birthday.toText,
      photoUrl: child.photoUrl,
    );
  }

  Child toDomain() {
    return Child(
      id: id,
      photoUrl: photoUrl,
      surname: Surname(surname),
      name: Name(name),
      birthday: Birthday.fromValue(birthday),
    );
  }

  factory ChildEntity.fromJson(Map<String, dynamic> json) =>
      _$ChildEntityFromJson(json);

  factory ChildEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>>doc) {
    //log("Debug doc.data >>>>>>>> ${doc.data} @ id = ${doc.documentID}");
    return ChildEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
