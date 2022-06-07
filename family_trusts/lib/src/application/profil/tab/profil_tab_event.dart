import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil_tab_event.freezed.dart';

@freezed
abstract class ProfilTabEvent with _$ProfilTabEvent {
  const factory ProfilTabEvent.init(ProfilTab currentTab) = Init;

  const factory ProfilTabEvent.gotoChildren() = GotoChildren;

  const factory ProfilTabEvent.gotoTrustedUsers() = GotoTrustedUsers;

  const factory ProfilTabEvent.gotoLocations() = GotoLocations;
}
