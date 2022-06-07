import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_form_event.freezed.dart';

@freezed
abstract class TrustedUserFormEvent with _$TrustedUserFormEvent {
  const factory TrustedUserFormEvent.userLookupChanged({
    required String userLookupText,
    required User currentUser,
  }) = UserLookupChanged;

  const factory TrustedUserFormEvent.addTrustedUser({
    required User currentUser,
    required User userToAdd,
    required TimestampVo time,
  }) = AddTrustedUser;

//const factory TrustedUserFormEvent.deleteTrustedUser({
//  required User currentUser,
//  required User userToRemove,
//  required TimestampVo time,
//}) = DeleteTrustedUser;
}
