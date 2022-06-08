import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'disconnect_user_failure.freezed.dart';

@freezed
class DisconnectUserFailure with _$DisconnectUserFailure {
  const factory DisconnectUserFailure.unexpected() = _Unexpected;
  const factory DisconnectUserFailure.insufficientPermission() = _InsufficientPermission;
  const factory DisconnectUserFailure.unknownUser(String userId) = _UnknownUser;
  const factory DisconnectUserFailure.unableToDisconnectUser() = _UnableToDisconnectUser;
}
