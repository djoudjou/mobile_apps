import 'package:another_flushbar/flushbar.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/home/tab/bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/application/messages/bloc.dart';
import 'package:familytrusts/src/application/notifications/unseen/notifications_unseen_bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/notification/i_familyevent_repository.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:familytrusts/src/presentation/ask/ask_page_tab.dart';
import 'package:familytrusts/src/presentation/core/error_scaffold.dart';
import 'package:familytrusts/src/presentation/core/loading_scaffold.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:familytrusts/src/presentation/demands/demands_page_tab.dart';
import 'package:familytrusts/src/presentation/home/widgets/my_bottom_navigation_bar.dart';
import 'package:familytrusts/src/presentation/notifications/notifications_page_tab.dart';
import 'package:familytrusts/src/presentation/profile/profile_page_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends MyBasePage {
  final AppTab currentTab;
  final String connectedUserId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key, required this.currentTab, required this.connectedUserId});

  @override
  Widget myBuild(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              NotificationsUnseenBloc(getIt<IFamilyEventRepository>())
                ..add(SimpleLoaderEvent.startLoading(userId: connectedUserId)),
        ),
        BlocProvider(
          create: (context) =>
              TabBloc()..add(TabEvent.init(currentTab, connectedUserId)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MessagesBloc, MessagesState>(
            listener: (contextMessagesBloc, state) {
              state.map(
                initial: (_) => null,
                tokenSaved: (tokenSaved) =>
                    log(" token >> ${tokenSaved.token} <<"),
                messageReceived: (MessageReceived value) {
                  log(" message >> $value <<");
                  Flushbar(
                    title: value.message.title,
                    //ignored since titleText != null
                    message: value.message.body,
                    backgroundGradient: LinearGradient(
                      colors: [
                        Theme.of(contextMessagesBloc).primaryColor,
                        Theme.of(contextMessagesBloc).primaryColorLight
                      ],
                    ),
                    backgroundColor: Theme.of(contextMessagesBloc).primaryColor,
                    duration: const Duration(seconds: 5),
                  ).show(contextMessagesBloc);
                  //showSuccessMessage(value.message.body, context);
                },
                errorReceived: (ErrorReceived value) {
                  log(" error >> $value <<");
                },
              );
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (contextUserBloc, state) {
            return state.map(
              userInitial: (UserInitial value) => const LoadingScaffold(),
              userNotFound: (UserNotFound value) => const ErrorScaffold(),
              userLoadFailure: (UserLoadFailure value) => const ErrorScaffold(),
              userLoadInProgress: (UserLoadInProgress value) =>
                  const LoadingScaffold(),
              userLoadSuccess: (UserLoadSuccess value) {
                final user = value.user;
                final spouse = value.spouse;

                return BlocBuilder<NotificationsUnseenBloc, SimpleLoaderState>(
                  builder: (contextNotificationsUnseenBloc, state) {
                    final int count = state.maybeMap(
                      simpleSuccessEventState: (simpleSuccessEventState) {
                        final Either<NotificationsFailure, int> nbUnReadResult =
                            simpleSuccessEventState.items
                                as Either<NotificationsFailure, int>;
                        return nbUnReadResult.fold((l) => 0, (r) => r);
                      },
                      simpleErrorEventState: (simpleErrorEventState) => 0,
                      orElse: () => 0,
                    );

                    return BlocBuilder<TabBloc, TabState>(
                      builder: (contextTabBloc, state) {
                        return Scaffold(
                          key: _scaffoldKey,
                          body: SafeArea(
                            child: state.map(
                              ask: (_) =>
                                  AskPageTab(user: user, spouse: spouse),
                              myDemands: (_) =>
                                  DemandsPageTab(user: user, spouse: spouse),
                              //lookup: (_) => LookupScreen(),
                              notification: (_) =>
                                  NotificationsPageTab(user: user, spouse: spouse),
                              me: (_) => ProfilePageTab(
                                connectedUser: user,
                                spouse: spouse,
                              ),
                            ),
                          ),
                          bottomNavigationBar: MyBottomNavigationBar(
                            activeTab: state.map(
                              ask: (_) => AppTab.ask,
                              myDemands: (_) => AppTab.myDemands,
                              //lookup: (_) => AppTab.lookup,
                              notification: (_) => AppTab.notification,
                              me: (_) => AppTab.me,
                            ),
                            nbNotificationsUnseen: count,
                            onTabSelected: (tab) {
                              switch (tab) {
                                case AppTab.me:
                                  contextTabBloc
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoMe());
                                  break;
                                case AppTab.ask:
                                  contextTabBloc
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoAsk());
                                  break;
                                case AppTab.myDemands:
                                  contextTabBloc
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoMyDemands());
                                  break;
                                case AppTab.notification:
                                  contextTabBloc
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoNotification());
                                  break;
                                /*
                              case AppTab.lookup:
                                tbc
                                    .read<TabBloc>()
                                    .add(const TabEvent.gotoLookup());
                                break;

                               */
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void refresh(BuildContext context) {
    BlocProvider.of<NotificationsUnseenBloc>(
      context,
    ).add(
      SimpleLoaderEvent.startLoading(userId: connectedUserId),
    );

    BlocProvider.of<MessagesBloc>(
      context,
    ).add(const MessagesEvent.init());

    BlocProvider.of<TabBloc>(
      context,
    ).add(TabEvent.init(currentTab, connectedUserId));
  }
}
