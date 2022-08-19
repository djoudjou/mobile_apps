import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/family_success.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_form_state.freezed.dart';

@freezed
class FamilyFormState with _$FamilyFormState {
  const factory FamilyFormState({
    required bool showErrorMessages,
    required FamilyFormStateEnum state,
    required bool isInitializing,
    required Name name,
    String? id,
    required Option<Either<FamilyFailure, FamilySuccess>>
        failureOrSuccessOption,
  }) = _FamilyFormState;

  factory FamilyFormState.initial() => FamilyFormState(
        showErrorMessages: false,
        state: FamilyFormStateEnum.none,
        isInitializing: true,
        failureOrSuccessOption: none(),
        name: Name(''),
      );
}
