import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.userInitial() = UserInitial;

  const factory UserState.userLoadInProgress(String userId) =
      UserLoadInProgress;

  const factory UserState.userLoadSuccess(
      {required User user,
      Invitation? spouseProposal,
      User? spouse}) = UserLoadSuccess;

  const factory UserState.userLoadFailure(String error) = UserLoadFailure;

  const factory UserState.userNotFound() = UserNotFound;
}
