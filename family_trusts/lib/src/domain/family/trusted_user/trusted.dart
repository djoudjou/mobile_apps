import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted.freezed.dart';

@freezed
abstract class TrustedUser implements _$TrustedUser {
  const TrustedUser._(); // Added constructor

  const factory TrustedUser({
    String? id,
    required FirstName firstName,
    required LastName lastName,
    required EmailAddress email,
    String? photoUrl,
    required PhoneNumber phoneNumber,
  }) = _TrustedUser;

  Option<ValueFailure<dynamic>> get failureOption {
    return firstName.failureOrUnit
        .andThen(lastName.failureOrUnit)
        .andThen(phoneNumber.failureOrUnit)
        .fold((f) => some(f), (_) => none());
  }

  String get displayName =>
      "${firstName.getOrCrash()} ${lastName.getOrCrash()}";
}
