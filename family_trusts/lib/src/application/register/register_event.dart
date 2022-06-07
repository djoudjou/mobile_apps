import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_event.freezed.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.init() = Init;

  const factory RegisterEvent.registerEmailChanged(String email) =
      RegisterEmailChanged;

  const factory RegisterEvent.registerPasswordChanged(String password) =
      RegisterPasswordChanged;

  const factory RegisterEvent.registerNameChanged(String name) =
      RegisterNameChanged;

  const factory RegisterEvent.registerSurnameChanged(String surname) =
      RegisterSurnameChanged;

  const factory RegisterEvent.registerSubmitted() = RegisterSubmitted;

  const factory RegisterEvent.registerPictureChanged(String pickedFilePath) = RegisterPictureChanged;
}
