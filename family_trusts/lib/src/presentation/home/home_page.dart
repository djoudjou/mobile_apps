import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/application/home/tab/bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/application/messages/bloc.dart';
import 'package:familytrusts/src/application/notifications/unseen/notifications_unseen_bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/notification/notifications_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/ask/ask_page.dart';
import 'package:familytrusts/src/presentation/core/error_scaffold.dart';
import 'package:familytrusts/src/presentation/core/loading_scaffold.dart';
import 'package:familytrusts/src/presentation/demands/demands_page.dart';
import 'package:familytrusts/src/presentation/home/widgets/my_bottom_navigation_bar.dart';
import 'package:familytrusts/src/presentation/notifications/notifications_page.dart';
import 'package:familytrusts/src/presentation/profile/profile_page.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget with LogMixin {
  final AppTab currentTab;
  final String connectedUserId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({Key? key, required this.currentTab, required this.connectedUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NotificationsUnseenBloc>()
            ..add(SimpleLoaderEvent.startLoading(connectedUserId)),
        ),
        BlocProvider(
          create: (context) => getIt<MessagesBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<TabBloc>()..add(TabEvent.init(currentTab, connectedUserId)),
        ),
        BlocProvider(
          create: (context) =>
              getIt<UserBloc>()..add(UserEvent.init(connectedUserId)),
        ),
        BlocProvider(create: (context) => getIt<SetupFamilyBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              state.map(
                initial: (_) {},
                authenticated: (e) {
                  context.read<UserBloc>().add(UserEvent.init(connectedUserId));
                },
                unauthenticated: (_) {
                  AutoRouter.of(context).popUntilRoot();
                  AutoRouter.of(context).replace(const SignInPageRoute());
                },
              );
            },
          ),
          BlocListener<MessagesBloc, MessagesState>(
            listener: (context, state) {
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
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight
                      ],
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: const Duration(seconds: 5),
                  ).show(context);
                  //showSuccessMessage(value.message.body, context);
                },
                errorReceived: (ErrorReceived value) {
                  log(" error >> $value <<");
                },
              );
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (userBlocCtx, state) {
              state.maybeMap(
                userLoadFailure: (e) {
                  showErrorMessage(
                    LocaleKeys.global_serverError.tr(),
                    userBlocCtx,
                  );
                  //AutoRouter.of(context).popUntilRoot();
                  AutoRouter.of(context).replace(const SignInPageRoute());
                },
                userNotFound: (e) {
                  //AutoRouter.of(context).popUntilRoot();
                  context.replaceRoute(const RegisterPageRoute());
                },
                userLoadSuccess: (e) {
                  userBlocCtx
                      .read<MessagesBloc>()
                      .add(MessagesEvent.saveToken(e.user.id!));

                  // si pas de famille -> redirige vers l'écran de création/rejoint de famille
                  if(e.user.notInFamily()) {
                    userBlocCtx.read<TabBloc>().add(const TabEvent.gotoMe());
                    context.popRoute();
                  }

                },
                orElse: () {},
              );
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return state.map(
              userInitial: (UserInitial value) => LoadingScaffold(),
              userNotFound: (UserNotFound value) => ErrorScaffold(),
              userLoadFailure: (UserLoadFailure value) => ErrorScaffold(),
              userLoadInProgress: (UserLoadInProgress value) =>
                  LoadingScaffold(),
              userLoadSuccess: (UserLoadSuccess value) {
                final user = value.user;
                final spouse = value.spouse;
                final spouseProposal = value.spouseProposal;

                return BlocBuilder<NotificationsUnseenBloc, SimpleLoaderState>(
                  builder: (context, state) {
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
                      builder: (context, state) {
                        return Scaffold(
                          key: _scaffoldKey,
                          body: SafeArea(
                            child: state.map(
                              ask: (_) => AskPage(user: user, spouse: spouse),
                              myDemands: (_) =>
                                  DemandsPage(user: user, spouse: spouse),
                              //lookup: (_) => LookupScreen(),
                              notification: (_) =>
                                  NotificationsPage(user: user, spouse: spouse),
                              me: (_) => ProfilePage(
                                connectedUser: user,
                                spouse: spouse,
                                spouseProposal: spouseProposal,
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
                                  context
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoMe());
                                  break;
                                case AppTab.ask:
                                  context
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoAsk());
                                  break;
                                case AppTab.myDemands:
                                  context
                                      .read<TabBloc>()
                                      .add(const TabEvent.gotoMyDemands());
                                  break;
                                case AppTab.notification:
                                  context
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
}
