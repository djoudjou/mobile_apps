import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/user/submit_user_failure.dart';
import 'package:familytrusts/src/domain/user/untrust_user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_form_state.freezed.dart';

@freezed
class UserFormState with _$UserFormState {
  const factory UserFormState({
    Surname? surname,
    Name? name,
    EmailAddress? emailAddress,
    String? imagePath,
    bool? submitUserEnable,
    bool? disconnectUserEnable,
    bool? unTrustUserEnable,
    required UserFormStateEnum status,
    required Option<Either<SubmitUserFailure, Unit>>
        submitUserFailureOrSuccessOption,
    required Option<Either<UnTrustUserFailure, Unit>>
        unTrustUserFailureOrSuccessOption,
  }) = _UserFormState;

  factory UserFormState.initial() => UserFormState(
        status: UserFormStateEnum.initializing,
        submitUserFailureOrSuccessOption: none(),
        unTrustUserFailureOrSuccessOption: none(),
      );
}
