import 'package:auto_route/auto_route.dart';
import 'package:familytrusts/src/application/auth/authentication_bloc.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (e) {
            AutoRouter.of(context).replace(HomePageRoute(
              currentTab: AppTab.ask,
              connectedUserId: e.userId,
            ));
          },
          unauthenticated: (_) {
            AutoRouter.of(context).replace(const SignInPageRoute());
          },
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
