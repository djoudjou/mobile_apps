import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/family/family.dart';
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
    Family? family,
    required FirstName firstName,
    required LastName lastName,
    String? photoUrl,
    String? spouse,
  }) = _User;

  Option<ValueFailure<dynamic>> get failureOption {
    return lastName.failureOrUnit
        .andThen(firstName.failureOrUnit)
        .andThen(email.failureOrUnit)
        .fold((f) => some(f), (_) => none());
  }

  String get displayName => "${firstName.getOrCrash()} ${lastName.getOrCrash()}";

  bool notInFamily() => family?.id == null;
}
