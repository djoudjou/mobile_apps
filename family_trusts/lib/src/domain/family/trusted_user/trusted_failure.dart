import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_failure.freezed.dart';

@freezed
abstract class TrustedUserFailure with _$TrustedUserFailure {
  const factory TrustedUserFailure.unexpected() = _Unexpected;

  const factory TrustedUserFailure.insufficientPermission() =
      _InsufficientPermission;

  const factory TrustedUserFailure.unableToAddTrustedUser() =
      _UnableToAddTrustedUser;
}
