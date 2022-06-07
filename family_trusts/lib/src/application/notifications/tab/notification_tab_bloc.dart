import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class NotificationTabBloc
    extends Bloc<NotificationTabEvent, NotificationTabState> {
  NotificationTabBloc() : super(NotificationTabState.initial());

  @override
  Stream<NotificationTabState> mapEventToState(
      NotificationTabEvent event) async* {
    yield* event.map(
      init: (Init value) async* {
        switch (value.currentTab) {
          case NotificationTab.demands:
            add(const NotificationTabEvent.gotoDemands());
            break;
          case NotificationTab.notifications:
            add(const NotificationTabEvent.gotoNotifications());
            break;
          case NotificationTab.invitations:
            add(const NotificationTabEvent.gotoInvitations());
            break;
        }
      },
      gotoInvitations: (GotoInvitations value) async* {
        yield state.copyWith(
          current: NotificationTab.invitations,
        );
      },
      gotoDemands: (GotoDemands value) async* {
        yield state.copyWith(
          current: NotificationTab.demands,
        );
      },
      gotoNotifications: (GotoNotifications value) async* {
        yield state.copyWith(
          current: NotificationTab.notifications,
        );
      },
    );
  }
}
