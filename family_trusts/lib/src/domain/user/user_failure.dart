import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_failure.freezed.dart';

@freezed
class UserFailure with _$UserFailure {
  const factory UserFailure.unexpected() = _Unexpected;
  const factory UserFailure.insufficientPermission() = _InsufficientPermission;
  const factory UserFailure.unknownUser(String userId) = _UnknownUser;
  const factory UserFailure.unableToUpdate() = _UnableToUpdate;
}
