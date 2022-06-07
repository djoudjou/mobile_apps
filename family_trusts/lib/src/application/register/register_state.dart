import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/register/register_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    required EmailAddress emailAddress,
    required Password password,
    required Surname surname,
    required Name name,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isInitializing,
    required bool isEditEmailPwdEnabled,
    String? imagePath,
    String? photoUrl,
    required
        Option<Either<RegisterFailure, String?>> registerFailureOrSuccessOption,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
        surname: Surname(''),
        name: Name(''),
        emailAddress: EmailAddress(''),
        password: Password(''),
        photoUrl: '',
        imagePath: '',
        registerFailureOrSuccessOption: none(),
        showErrorMessages: false,
        isSubmitting: false,
        isInitializing: true,
        isEditEmailPwdEnabled: false,
      );
}
