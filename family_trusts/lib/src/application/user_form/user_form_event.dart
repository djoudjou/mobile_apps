import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_form_event.freezed.dart';

@freezed
class UserFormEvent with _$UserFormEvent {
  const factory UserFormEvent.init({required User userToEdit,required User connectedUser}) = Init;

  const factory UserFormEvent.nameChanged(String name) = NameChanged;

  const factory UserFormEvent.surnameChanged(String surname) = SurnameChanged;

  const factory UserFormEvent.pictureChanged(String pickedFilePath) =
      PictureChanged;

  const factory UserFormEvent.userSubmitted({
    String? pickedFilePath,
    required User user,
    required User connectedUser,
  }) = UserSubmitted;

  const factory UserFormEvent.userUntrusted({
    required User user,
    required User connectedUser,
  }) = UserUntrusted;
}
