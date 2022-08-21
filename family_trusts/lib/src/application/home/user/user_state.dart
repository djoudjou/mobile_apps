import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.userInitial() = UserInitial;

  const factory UserState.userLoadInProgress(String userId) =
      UserLoadInProgress;

  const factory UserState.userLoadSuccess({
    required User user,
    User? spouse,
  }) = UserLoadSuccess;

  const factory UserState.userLoadFailure(String error) = UserLoadFailure;

  const factory UserState.userNotFound() = UserNotFound;
}
