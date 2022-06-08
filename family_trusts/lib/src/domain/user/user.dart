import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
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
}
