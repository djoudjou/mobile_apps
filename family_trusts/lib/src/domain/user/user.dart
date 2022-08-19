import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/http/families/family_dto.dart';
import 'package:familytrusts/src/domain/http/persons/person_dto.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._(); // Added constructor

  const factory User({
    String? id,
    required EmailAddress email,
    String? familyId,
    required Name name,
    required Surname surname,
    String? photoUrl,
    String? spouse,
  }) = _User;

  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit
        .andThen(surname.failureOrUnit)
        .andThen(email.failureOrUnit)
        .fold((f) => some(f), (_) => none());
  }

  String get displayName => "${surname.getOrCrash()} ${name.getOrCrash()}";

  bool notInFamily() => familyId == null;

  factory User.fromDTO(PersonDTO personDTO, FamilyDTO? familyDTO) {
    final PersonDTO? spouse = (familyDTO != null && familyDTO.members != null)
        ? familyDTO.members
            ?.firstWhere((element) => element.personId != personDTO.personId)
        : null;

    return User(
      email: EmailAddress(personDTO.email),
      name: Name(personDTO.lastName),
      surname: Surname(personDTO.firstName),
      photoUrl: personDTO.photoUrl,
      id: personDTO.personId,
      familyId: familyDTO?.familyId,
      spouse: spouse?.personId,
    );
  }
}
