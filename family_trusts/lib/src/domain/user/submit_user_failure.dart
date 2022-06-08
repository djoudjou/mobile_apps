import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'submit_user_failure.freezed.dart';

@freezed
class SubmitUserFailure with _$SubmitUserFailure {
  const factory SubmitUserFailure.unexpected() = _Unexpected;
  const factory SubmitUserFailure.insufficientPermission() = _InsufficientPermission;
  const factory SubmitUserFailure.unableToSubmitUser() = _UnableToSubmitUser;
}
