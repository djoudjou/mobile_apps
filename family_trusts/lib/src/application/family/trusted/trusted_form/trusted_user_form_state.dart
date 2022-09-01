import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_form_state.freezed.dart';

@freezed
class TrustedUserFormState with _$TrustedUserFormState {

  const factory TrustedUserFormState({
    required TrustedUserFormStateEnum state,
    required Option<Either<SearchUserFailure, List<User>>> searchUserFailureOrSuccessOption,
    required Option<Either<TrustedUserFailure, Unit>> addTrustedUserFailureOrSuccessOption,
  }) = _TrustedUserFormState;

  factory TrustedUserFormState.initial() => TrustedUserFormState(
    state: TrustedUserFormStateEnum.none,
    searchUserFailureOrSuccessOption: none(),
    addTrustedUserFailureOrSuccessOption: none(),
  );
}
