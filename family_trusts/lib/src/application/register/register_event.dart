import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_event.freezed.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.init() = Init;

  const factory RegisterEvent.registerEmailChanged(String email) =
      RegisterEmailChanged;

  const factory RegisterEvent.registerPasswordChanged(String password) =
      RegisterPasswordChanged;

  const factory RegisterEvent.registerLastNameChanged(String lastName) =
      RegisterLastNameChanged;

  const factory RegisterEvent.registerFirstNameChanged(String firstName) =
      RegisterFirstNameChanged;

  const factory RegisterEvent.registerSubmitted() = RegisterSubmitted;

  const factory RegisterEvent.registerPictureChanged(String pickedFilePath) = RegisterPictureChanged;
}
