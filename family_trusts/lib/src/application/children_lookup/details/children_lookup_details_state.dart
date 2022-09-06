import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_details.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_details_state.freezed.dart';

@freezed
class ChildrenLookupDetailsState with _$ChildrenLookupDetailsState {
  const factory ChildrenLookupDetailsState({
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isInitializing,
    required bool isIssuer,
    required Option<ChildrenLookupDetails> optionChildrenLookupDetails,
    required Option<Either<ChildrenLookupFailure, Unit>>
        failureOrSuccessCancelOption,
  }) = _ChildrenLookupDetailsState;

  factory ChildrenLookupDetailsState.initial() => ChildrenLookupDetailsState(
        showErrorMessages: false,
        isInitializing: true,
        isSubmitting: false,
        isIssuer: false,
        optionChildrenLookupDetails: none(),
        failureOrSuccessCancelOption: none(),
      );
}
