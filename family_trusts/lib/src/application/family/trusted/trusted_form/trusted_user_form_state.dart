import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_form_state.freezed.dart';

@freezed
class TrustedUserFormState with _$TrustedUserFormState {
  const factory TrustedUserFormState({
    LastName? lastName,
    FirstName? firstName,
    PhoneNumber? phoneNumber,
    String? imagePath,
    required bool deleteEnable,
    required TrustedUserFormStateEnum status,
    required Option<Either<TrustedUserFailure, Unit>>
        submitTrustedUserFailureOrSuccessOption,
    required Option<Either<TrustedUserFailure, Unit>>
        removeTrustedUserFailureOrSuccessOption,
  }) = _TrustedUserFormState;

  factory TrustedUserFormState.initial() => TrustedUserFormState(
        status: TrustedUserFormStateEnum.initializing,
        deleteEnable: false,
        submitTrustedUserFailureOrSuccessOption: none(),
        removeTrustedUserFailureOrSuccessOption: none(),
      );
}
