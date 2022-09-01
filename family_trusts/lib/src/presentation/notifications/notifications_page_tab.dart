import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/notifications/tab/bloc.dart';
import 'package:familytrusts/src/domain/notification/notification_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_drawer.dart';
import 'package:familytrusts/src/presentation/notifications/widgets/events_tab.dart';
import 'package:familytrusts/src/presentation/notifications/widgets/invitations_tab.dart';
import 'package:familytrusts/src/presentation/notifications/widgets/planning_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsPageTab extends StatelessWidget {
  final User user;
  final User? spouse;

  const NotificationsPageTab({
    Key? key,
    required this.user,
    this.spouse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationTabBloc(),
        ),
      ],
      child: NotificationsPageTabStateFull(
        user: user,
        spouse: spouse,
      ),
    );
  }
}

class NotificationsPageTabStateFull extends StatefulWidget {
  final User user;
  final User? spouse;

  const NotificationsPageTabStateFull({
    Key? key,
    required this.user,
    this.spouse,
  }) : super(key: key);

  @override
  _NotificationsPageTabState createState() => _NotificationsPageTabState();
}

class _NotificationsPageTabState extends State<NotificationsPageTabStateFull>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    )..addListener(
        () {
          final notificationTabBloc = BlocProvider.of<NotificationTabBloc>(
            context,
          );
          if (_tabController?.index == 0) {
            notificationTabBloc.add(const NotificationTabEvent.gotoDemands());
          } else if (_tabController?.index == 1) {
            notificationTabBloc
                .add(const NotificationTabEvent.gotoInvitations());
          } else if (_tabController?.index == 2) {
            notificationTabBloc
                .add(const NotificationTabEvent.gotoNotifications());
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationTabBloc, NotificationTabState>(
          listener: (context, state) {
            switch (state.current) {
              case NotificationTab.demands:
                _tabController?.index = 0;
                break;
              case NotificationTab.invitations:
                _tabController?.index = 1;
                break;
              case NotificationTab.notifications:
                _tabController?.index = 2;
                break;
            }
          },
        ),
      ],
      child: BlocBuilder<NotificationTabBloc, NotificationTabState>(
        builder: (context, state) {
          switch (state.current) {
            case NotificationTab.demands:
              _tabController?.index = 0;
              break;
            case NotificationTab.invitations:
              _tabController?.index = 1;
              break;
            case NotificationTab.notifications:
              _tabController?.index = 2;
              break;
          }

          return DefaultTabController(
            length: 3, // This is the number of tabs.
            child: Scaffold(
              drawer: MyDrawer(user: widget.user, spouse: widget.spouse),
              appBar: MyAppBar(
                context: context,
                pageTitle: LocaleKeys.notifications_title.tr(),
                bottom: TabBar(
                  onTap: (index) {
                    final notificationTabBloc =
                        context.read<NotificationTabBloc>();
                    if (index == 0) {
                      notificationTabBloc
                          .add(const NotificationTabEvent.gotoDemands());
                    } else if (index == 1) {
                      notificationTabBloc
                          .add(const NotificationTabEvent.gotoInvitations());
                    } else if (index == 2) {
                      notificationTabBloc.add(
                        const NotificationTabEvent.gotoNotifications(),
                      );
                    }
                  },
                  isScrollable: true,
                  controller: _tabController,
                  tabs: <Tab>[
                    const Tab(
                      text: "Tableau de bord",
                      icon: Icon(FontAwesomeIcons.calendar),
                    ),
                    Tab(
                      text: LocaleKeys.notifications_invitations_tab.tr(),
                      icon: const Icon(FontAwesomeIcons.envelope),
                    ),
                    Tab(
                      text: LocaleKeys.notifications_events_tab.tr(),
                      icon: const Icon(FontAwesomeIcons.bell),
                    )
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  //DemandsTab(connectedUser: widget.user,),
                  PlanningTab(
                    connectedUser: widget.user,
                  ),
                  InvitationsTab(
                    connectedUser: widget.user,
                  ),
                  EventsTab(
                    connectedUser: widget.user,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
