import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/user/submit_user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_form_state.freezed.dart';

@freezed
class UserFormState with _$UserFormState {
  const factory UserFormState({
    LastName? lastName,
    FirstName? firstName,
    EmailAddress? emailAddress,
    String? imagePath,
    bool? submitUserEnable,
    bool? disconnectUserEnable,
    required UserFormStateEnum status,
    required Option<Either<SubmitUserFailure, Unit>>
        submitUserFailureOrSuccessOption,
    required Option<Either<FamilyFailure, Unit>>
        leaveFamilyFailureOrSuccessOption,
  }) = _UserFormState;

  factory UserFormState.initial() => UserFormState(
        status: UserFormStateEnum.initializing,
        submitUserFailureOrSuccessOption: none(),
        leaveFamilyFailureOrSuccessOption: none(),
      );
}
