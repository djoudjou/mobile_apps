import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_form_event.freezed.dart';

@freezed
class UserFormEvent with _$UserFormEvent {
  const factory UserFormEvent.init({
    required User userToEdit,
    required User connectedUser,
  }) = Init;

  const factory UserFormEvent.leaveFamily({
    required User connectedUser,
    required Family family,
  }) = LeaveFamily;

  const factory UserFormEvent.nameChanged(String name) = NameChanged;

  const factory UserFormEvent.surnameChanged(String surname) = SurnameChanged;

  const factory UserFormEvent.pictureChanged(String pickedFilePath) =
      PictureChanged;

  const factory UserFormEvent.userSubmitted({
    String? pickedFilePath,
    required User user,
    required User connectedUser,
  }) = UserSubmitted;
}
