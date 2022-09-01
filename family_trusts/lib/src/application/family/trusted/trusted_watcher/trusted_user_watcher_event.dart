import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_watcher_event.freezed.dart';

@freezed
abstract class TrustedUserWatcherEvent with _$TrustedUserWatcherEvent {
  const factory TrustedUserWatcherEvent.loadTrustedUsers(String? familyId) =
      LoadTrustedUsers;
}
