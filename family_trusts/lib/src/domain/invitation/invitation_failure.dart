import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitation_failure.freezed.dart';

@freezed
abstract class InvitationFailure with _$InvitationFailure {
  const factory InvitationFailure.unexpected() = _Unexpected;
  const factory InvitationFailure.insufficientPermission() = _InsufficientPermission;
  const factory InvitationFailure.unableToUpdate() = _UnableToUpdate;
  const factory InvitationFailure.unknownUser(String userId) = _UnknownUser;
}
