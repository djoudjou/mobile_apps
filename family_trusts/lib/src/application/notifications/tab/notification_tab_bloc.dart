import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/notifications/tab/bloc.dart';
import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationTabBloc
    extends Bloc<NotificationTabEvent, NotificationTabState> {
  NotificationTabBloc() : super(NotificationTabState.initial()) {
    on<Init>(_mapInit, transformer: restartable());
    on<GotoDemands>(_mapGotoDemands, transformer: restartable());
    on<GotoInvitations>(_mapGotoInvitations, transformer: restartable());
    on<GotoNotifications>(_mapGotoNotifications, transformer: restartable());
  }

  FutureOr<void> _mapInit(Init event, Emitter<NotificationTabState> emit) {
    switch (event.currentTab) {
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
  }

  FutureOr<void> _mapGotoDemands(
    GotoDemands event,
    Emitter<NotificationTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: NotificationTab.demands,
      ),
    );
  }

  FutureOr<void> _mapGotoInvitations(
    GotoInvitations event,
    Emitter<NotificationTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: NotificationTab.invitations,
      ),
    );
  }

  FutureOr<void> _mapGotoNotifications(
    GotoNotifications event,
    Emitter<NotificationTabState> emit,
  ) {
    emit(
      state.copyWith(
        current: NotificationTab.notifications,
      ),
    );
  }
}
