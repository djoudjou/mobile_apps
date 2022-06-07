import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/location/complex_address.dart';
import 'package:familytrusts/src/domain/location/search_location_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'search_location_state.freezed.dart';

@freezed
class SearchLocationState with _$SearchLocationState {
  const factory SearchLocationState({
    required bool isSubmitting,
    required
        Option<Either<SearchLocationFailure, List<ComplexAddress>>>
            searchLocationFailureOrSuccessOption,
  }) = _SearchLocationState;

  factory SearchLocationState.initial() => SearchLocationState(
        searchLocationFailureOrSuccessOption: none(),
        isSubmitting: false,
      );
}
