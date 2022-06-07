import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'value_objects.dart';

part 'invitation.freezed.dart';

@freezed
class Invitation with _$Invitation {
  const Invitation._(); // Added constructor
  const factory Invitation({
    required User from,
    required User to,
    required TimestampVo date,
    required InvitationType type,
  }) = _Invitation;

  Option<ValueFailure<dynamic>> get failureOption {
    return date.value.fold((f) => some(f), (_) => none());
  }
}
