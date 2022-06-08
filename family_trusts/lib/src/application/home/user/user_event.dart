import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_event.freezed.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.init(String connectedUserId) = Init;

  const factory UserEvent.userStarted(String userId) = UserStarted;

  const factory UserEvent.userReceived(
    Either<UserFailure, User> failureOrUser,
  ) = UserReceived;

  const factory UserEvent.userSubmitted({
    String? pickedFilePath,
    required User user,
  }) = UserSubmitted;
}
