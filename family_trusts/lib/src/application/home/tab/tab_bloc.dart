import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/home/tab/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState.ask()) {
    on<TabEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: sequential(),
    );
  }

  void mapEventToState(
    TabEvent event,
    Emitter<TabState> emit,
  ) {
    event.map(
      gotoAsk: (e) {
        emit(const TabState.ask());
      },
      gotoMyDemands: (e) {
        emit(const TabState.myDemands());
      },
      //gotoLookup: (e) async* {
      //  yield TabState.lookup(state.optionFailureOrNotifications);
      //},
      gotoNotification: (e) {
        emit(const TabState.notification());
      },
      gotoMe: (e) {
        emit(const TabState.me());
      },
      init: (Init value) {
        switch (value.currentTab) {
          case AppTab.ask:
            add(const TabEvent.gotoAsk());
            break;
          //case AppTab.lookup:
          //  add(const TabEvent.gotoLookup());
          //  break;
          case AppTab.me:
            add(const TabEvent.gotoMe());
            break;
          case AppTab.myDemands:
            add(const TabEvent.gotoMyDemands());
            break;
          case AppTab.notification:
            add(const TabEvent.gotoNotification());
            break;
        }
      },
    );
  }
}
