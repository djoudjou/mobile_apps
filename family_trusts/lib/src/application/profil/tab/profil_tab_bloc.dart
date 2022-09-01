import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  ProfileTabBloc() : super(ProfileTabState.initial()) {
    on<Init>(_mapInit, transformer: restartable());
    on<GotoChildren>(_mapGotoChildren, transformer: restartable());
    on<GotoTrustedUsers>(_mapGotoTrustedUsers, transformer: restartable());
    on<GotoLocations>(_mapGotoLocations, transformer: restartable());
  }

  FutureOr<void> _mapInit(Init event, Emitter<ProfileTabState> emit) {
    switch (event.currentTab) {
      case ProfilTab.children:
        add(const ProfileTabEvent.gotoChildren());
        break;
      case ProfilTab.trustedUsers:
        add(const ProfileTabEvent.gotoTrustedUsers());
        break;
      case ProfilTab.locations:
        add(const ProfileTabEvent.gotoLocations());
        break;
    }
  }

  FutureOr<void> _mapGotoChildren(
    GotoChildren event,
    Emitter<ProfileTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: ProfilTab.children,
      ),
    );
  }

  FutureOr<void> _mapGotoTrustedUsers(
    GotoTrustedUsers event,
    Emitter<ProfileTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: ProfilTab.trustedUsers,
      ),
    );
  }

  FutureOr<void> _mapGotoLocations(
    GotoLocations event,
    Emitter<ProfileTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: ProfilTab.locations,
      ),
    );
  }
}
