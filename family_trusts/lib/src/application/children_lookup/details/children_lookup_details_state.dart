import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'children_lookup_details_state.freezed.dart';

@freezed
class ChildrenLookupDetailsState with _$ChildrenLookupDetailsState {
  const factory ChildrenLookupDetailsState({
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isInitializing,
    required bool isIssuer,
    required bool isTrustedUser,
    required bool displayDeclineButton,
    required bool displayAcceptButton,
    required bool displayEndedButton,
    required bool displayCancelButton,
    ChildrenLookup? childrenLookup,
    required
        Option<Either<ChildrenLookupFailure, List<ChildrenLookupHistory>>>
            optionEitherChildrenLookupHistory,
    required
        Option<Either<ChildrenLookupFailure, Unit>> failureOrSuccessOption,
  }) = _ChildrenLookupDetailsState;

  factory ChildrenLookupDetailsState.initial() => ChildrenLookupDetailsState(
        showErrorMessages: false,
        isInitializing: true,
        isSubmitting: false,
        isIssuer: false,
        isTrustedUser: false,
        displayDeclineButton: false,
        displayAcceptButton: false,
        displayEndedButton: false,
        displayCancelButton: false,
        failureOrSuccessOption: none(),
        optionEitherChildrenLookupHistory: none(),
      );
}
