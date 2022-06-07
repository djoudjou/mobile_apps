import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
 class UserEntity with _$UserEntity {
  const UserEntity._(); // Added constructor

  const factory UserEntity({
    //@JsonKey(ignore: true)
    String? id,
    String? familyId,
    required String email,
    required String name,
    required String surname,
    String? photoUrl,
    String? spouse,
  }) = _UserEntity;

  factory UserEntity.fromDomain(User user) {
    return UserEntity(
      id: user.id,
      name: user.name.getOrCrash(),
      surname: user.surname.getOrCrash(),
      email: user.email.getOrCrash(),
      photoUrl: user.photoUrl,
      spouse: user.spouse,
      familyId: user.familyId,
    );
  }

  User toDomain() {
    return User(
      email: EmailAddress(email),
      id: id,
      spouse: spouse,
      photoUrl: photoUrl,
      surname: Surname(surname),
      name: Name(name),
      familyId: familyId,
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  factory UserEntity.fromFirestore(DocumentSnapshot<Map<String, dynamic>>doc) {
    return UserEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
