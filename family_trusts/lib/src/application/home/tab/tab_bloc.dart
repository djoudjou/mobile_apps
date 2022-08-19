import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/home/tab/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState.ask()) {
    on<Init>(_mapInit, transformer: sequential());
    on<GotoAsk>(_mapGotoAsk, transformer: sequential());
    on<GotoMyDemands>(_mapGotoMyDemands, transformer: sequential());
    on<GotoNotification>(_mapGotoNotification, transformer: sequential());
    on<GotoMe>(_mapGotoMe, transformer: sequential());
  }

  FutureOr<void> _mapInit(Init event, Emitter<TabState> emit) {
    switch (event.currentTab) {
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
  }

  FutureOr<void> _mapGotoAsk(GotoAsk event, Emitter<TabState> emit) {
    emit(const TabState.ask());
  }

  FutureOr<void> _mapGotoMyDemands(
      GotoMyDemands event, Emitter<TabState> emit) {
    emit(const TabState.myDemands());
  }

  FutureOr<void> _mapGotoNotification(
      GotoNotification event, Emitter<TabState> emit) {
    emit(const TabState.notification());
  }

  FutureOr<void> _mapGotoMe(GotoMe event, Emitter<TabState> emit) {
    emit(const TabState.me());
  }
}
