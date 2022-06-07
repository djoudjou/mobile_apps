import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil_tab_state.freezed.dart';

@freezed
abstract class ProfilTabState with _$ProfilTabState {
  const factory ProfilTabState({required ProfilTab current}) = _ProfilTabState;

  factory ProfilTabState.initial() =>
      const ProfilTabState(current: ProfilTab.trustedUsers);
}
