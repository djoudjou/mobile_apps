import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState.ask());

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    yield* event.map(
      gotoAsk: (e) async* {
        yield const TabState.ask();
      },
      gotoMyDemands: (e) async* {
        yield const TabState.myDemands();
      },
      //gotoLookup: (e) async* {
      //  yield TabState.lookup(state.optionFailureOrNotifications);
      //},
      gotoNotification: (e) async* {
        yield const TabState.notification();
      },
      gotoMe: (e) async* {
        yield const TabState.me();
      },
      init: (Init value) async* {
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
