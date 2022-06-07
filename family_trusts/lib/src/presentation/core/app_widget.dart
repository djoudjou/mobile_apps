import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/core/simple_navigator_observer.dart';
import 'package:familytrusts/src/application/messages/bloc.dart';
import 'package:familytrusts/src/application/notifications/tab/bloc.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/routes/auth_guard.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart'
    as router_gr;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../injection.dart';

class AppWidget extends StatelessWidget with LogMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final appRouter = router_gr.MyAppRouter(authGuard: AuthGuard());

  @override
  Widget build(BuildContext context) {
    log(context.locale.toString());

    final MaterialApp materialApp = MaterialApp.router(
      title: 'family trust',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      key: _scaffoldKey,
      routerDelegate: appRouter.delegate(
        initialRoutes: [const router_gr.SplashPageRoute()],
        navigatorObservers: () => [
          AutoRouteObserver(),
          FirebaseAnalyticsObserver(analytics: getIt<FirebaseAnalytics>()),
          SentryNavigatorObserver(), // for sent navigator observer
          LoggerNavigatorObserver(),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      builder: (_, router) {
        log(".... $router");
        return router!;
      },
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontFamily: 'Hind',
            color: Colors.black,
          ),
        ),
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
        focusColor: Colors.red,
        backgroundColor: Colors.indigo,
        dividerColor: Colors.grey,
        primarySwatch: primaryColor,
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
          ),
        ),
        buttonTheme: ButtonThemeData(
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[900],
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(
            fontSize: 20,
            decorationColor: Colors.grey,
          ),
        ),
      ),
    );

    log(" debug material #${materialApp.title}");
    log(" debug material #${materialApp.routerDelegate}");
    log(" debug material #${materialApp.routeInformationParser}");

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                getIt<MessagesBloc>()..add(const MessagesEvent.init())),
        BlocProvider(
            create: (context) => getIt<AuthenticationBloc>()
              ..add(const AuthenticationEvent.authCheckRequested())),
        BlocProvider(
          create: (context) => getIt<ProfilTabBloc>()
              ..add(const ProfilTabEvent.gotoChildren()),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationTabBloc>(),
        )
      ],
      child: materialApp,
    );
    /*
        builder: ExtendedNavigator.builder(
          router: router_gr.Router(),
          guards: [AuthGuard()],
          observers: [
            FirebaseAnalyticsObserver(analytics: getIt<FirebaseAnalytics>()),
            SentryNavigatorObserver(), // for sent navigator observer
          ],
          builder: (context, extendedNav) =>
              Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                  textTheme: const TextTheme(
                    headline1: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                    bodyText1: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Hind',
                      color: Colors.black,
                    ),
                  ),
                  //primaryColor: Colors.blue,
                  //accentColor: Colors.blueAccent,
                  //focusColor: Colors.red,
                  //backgroundColor: Colors.indigo,
                  //dividerColor: Colors.grey,
                  primarySwatch: primaryColor,
                  tabBarTheme: const TabBarTheme(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                  ),
                  cardTheme: CardTheme(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  buttonTheme: ButtonThemeData(
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.blue[900],
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      decorationColor: Colors.grey,
                    ),
                  ),
                ),
                child: extendedNav,
              ),
        ),
        */
  }
}
