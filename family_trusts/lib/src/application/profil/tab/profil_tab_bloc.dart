import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class ProfilTabBloc extends Bloc<ProfilTabEvent, ProfilTabState> {
  ProfilTabBloc() : super(ProfilTabState.initial());

  @override
  Stream<ProfilTabState> mapEventToState(ProfilTabEvent event) async* {
    yield* event.map(
      init: (Init value) async* {
        switch (value.currentTab) {
          case ProfilTab.children:
            add(const ProfilTabEvent.gotoChildren());
            break;
          case ProfilTab.trustedUsers:
            add(const ProfilTabEvent.gotoTrustedUsers());
            break;
          case ProfilTab.locations:
            add(const ProfilTabEvent.gotoLocations());
            break;
        }
      },
      gotoChildren: (GotoChildren value) async* {
        yield state.copyWith(
          current: ProfilTab.children,
        );
      },
      gotoTrustedUsers: (GotoTrustedUsers value) async* {
        yield state.copyWith(
          current: ProfilTab.trustedUsers,
        );
      },
      gotoLocations: (GotoLocations value) async* {
        yield state.copyWith(
          current: ProfilTab.locations,
        );
      },
    );
  }
}
