import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil_tab_state.freezed.dart';

@freezed
abstract class ProfileTabState with _$ProfileTabState {
  const factory ProfileTabState({required ProfilTab current}) = _ProfileTabState;

  factory ProfileTabState.initial() =>
      const ProfileTabState(current: ProfilTab.trustedUsers);
}
