import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil_tab_event.freezed.dart';

@freezed
abstract class ProfileTabEvent with _$ProfileTabEvent {
  const factory ProfileTabEvent.init(ProfilTab currentTab) = Init;

  const factory ProfileTabEvent.gotoChildren() = GotoChildren;

  const factory ProfileTabEvent.gotoTrustedUsers() = GotoTrustedUsers;

  const factory ProfileTabEvent.gotoLocations() = GotoLocations;
}
