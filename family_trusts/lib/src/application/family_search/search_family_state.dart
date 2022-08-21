import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/search_family_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_family_state.freezed.dart';

@freezed
class SearchFamilyState with _$SearchFamilyState {
  const factory SearchFamilyState({
    required bool isSubmitting,
    required Option<Either<SearchFamilyFailure, List<Family>>>
        searchFamilyFailureOrSuccessOption,
  }) = _SearchFamilyState;

  factory SearchFamilyState.initial() => SearchFamilyState(
        searchFamilyFailureOrSuccessOption: none(),
        isSubmitting: false,
      );
}
