import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilTabBloc extends Bloc<ProfilTabEvent, ProfilTabState> {
  ProfilTabBloc() : super(ProfilTabState.initial()) {
    on<ProfilTabEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  void mapEventToState(
    ProfilTabEvent event,
    Emitter<ProfilTabState> emit,
  ) {
    event.map(
      init: (Init value) {
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
      gotoChildren: (GotoChildren value) {
        emit(
          state.copyWith(
            current: ProfilTab.children,
          ),
        );
      },
      gotoTrustedUsers: (GotoTrustedUsers value) {
        emit(
          state.copyWith(
            current: ProfilTab.trustedUsers,
          ),
        );
      },
      gotoLocations: (GotoLocations value) {
        emit(
          state.copyWith(
            current: ProfilTab.locations,
          ),
        );
      },
    );
  }
}
