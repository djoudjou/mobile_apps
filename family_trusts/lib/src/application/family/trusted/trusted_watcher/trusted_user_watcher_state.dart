import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_watcher_state.freezed.dart';

@freezed
class TrustedUserWatcherState with _$TrustedUserWatcherState {
  const factory TrustedUserWatcherState.trustedUsersLoading() =
      TrustedUsersLoading;

  const factory TrustedUserWatcherState.trustedUsersLoaded({
    required Either<TrustedUserFailure, List<TrustedUser>> eitherTrustedUsers,
  }) = TrustedUsersLoaded;

  const factory TrustedUserWatcherState.trustedUsersNotLoaded() =
      TrustedUsersNotLoaded;
}
