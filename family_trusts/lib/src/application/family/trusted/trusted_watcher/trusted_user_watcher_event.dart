import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_watcher_event.freezed.dart';

@freezed
abstract class TrustedUserWatcherEvent with _$TrustedUserWatcherEvent {
  const factory TrustedUserWatcherEvent.loadTrustedUsers(String? familyId) =
      LoadTrustedUsers;

  const factory TrustedUserWatcherEvent.trustedUsersUpdated(
          {required Either<UserFailure,List<TrustedUser>> eitherTrustedUsers}) = TrustedUsersUpdated;
}
