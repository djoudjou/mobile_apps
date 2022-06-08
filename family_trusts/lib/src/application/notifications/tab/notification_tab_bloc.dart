import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/notifications/tab/bloc.dart';
import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationTabBloc
    extends Bloc<NotificationTabEvent, NotificationTabState> {
  NotificationTabBloc() : super(NotificationTabState.initial()) {
    on<NotificationTabEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  void mapEventToState(
    NotificationTabEvent event,
    Emitter<NotificationTabState> emit,
  ) {
    event.map(
      init: (Init value) {
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
      gotoInvitations: (GotoInvitations value) {
        emit(
          state.copyWith(
            current: NotificationTab.invitations,
          ),
        );
      },
      gotoDemands: (GotoDemands value) {
        emit(
          state.copyWith(
            current: NotificationTab.demands,
          ),
        );
      },
      gotoNotifications: (GotoNotifications value) {
        emit(
          state.copyWith(
            current: NotificationTab.notifications,
          ),
        );
      },
    );
  }
}
