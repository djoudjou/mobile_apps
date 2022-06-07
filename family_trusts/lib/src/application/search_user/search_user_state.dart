import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'search_user_state.freezed.dart';

@freezed
class SearchUserState with _$SearchUserState {
  const factory SearchUserState({
    required bool isSubmitting,
    required
        Option<Either<SearchUserFailure, Stream<List<User>>>>
            searchUserFailureOrSuccessOption,
  }) = _SearchUserState;

  factory SearchUserState.initial() => SearchUserState(
        searchUserFailureOrSuccessOption: none(),
        isSubmitting: false,
      );
}
