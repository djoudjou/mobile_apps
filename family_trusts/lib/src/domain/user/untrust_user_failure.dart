import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'untrust_user_failure.freezed.dart';

@freezed
class UnTrustUserFailure with _$UnTrustUserFailure {
  const factory UnTrustUserFailure.unexpected() = _Unexpected;
  const factory UnTrustUserFailure.insufficientPermission() = _InsufficientPermission;
  const factory UnTrustUserFailure.unableToUnTrust() = _UnableToUnTrust;
}
