import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/register/register_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    required EmailAddress emailAddress,
    required Password password,
    required LastName lastName,
    required FirstName firstName,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isInitializing,
    required bool isEditEmailPwdEnabled,
    String? imagePath,
    String? photoUrl,
    required Option<Either<RegisterFailure, String?>>
        registerFailureOrSuccessOption,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
        lastName: LastName(''),
        firstName: FirstName(''),
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
