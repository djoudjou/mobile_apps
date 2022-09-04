import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_form_event.freezed.dart';

@freezed
abstract class TrustedUserFormEvent with _$TrustedUserFormEvent {
  const factory TrustedUserFormEvent.init({
    required TrustedUser toEdit,
    required User connectedUser,
  }) = Init;

  const factory TrustedUserFormEvent.firstNameChanged(String firstName) =
      FirstNameChanged;

  const factory TrustedUserFormEvent.lastNameChanged(String lastName) =
      LastNameChanged;

  const factory TrustedUserFormEvent.phoneNumberChanged(String phoneNumber) =
      PhoneNumberChanged;

  const factory TrustedUserFormEvent.pictureChanged(String pickedFilePath) =
      PictureChanged;

  const factory TrustedUserFormEvent.removeTrustedUser({
    required String trustedUserId,
    required String familyId,
  }) = RemoveTrustedUser;

  const factory TrustedUserFormEvent.submitted({
    String? pickedFilePath,
    required TrustedUser trustedUser,
    required User connectedUser,
  }) = Submitted;
}
