import 'package:auto_route/auto_route.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget with LogMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (userBlocContext, state) {
            if (state is UserLoadFailure) {
              //showErrorMessage(LocaleKeys.global_serverError.tr(),context,);
              AutoRouter.of(userBlocContext).replace(const SignInPageRoute());
            } else if (state is UserLoadSuccess) {
              final User user = state.user;

              if (user.notInFamily()) {
                // navigation ver
                AutoRouter.of(userBlocContext).replace(
                  HomePageWithoutFamilyRoute(
                    connectedUser: user,
                  ),
                );
              } else {
                AutoRouter.of(userBlocContext).replace(
                  HomePageRoute(
                    currentTab: AppTab.ask,
                    connectedUserId: user.id!,
                  ),
                );
              }
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (authenticationBlocContext, state) {
            state.map(
              initial: (_) {},
              authenticated: (event) {
                BlocProvider.of<UserBloc>(authenticationBlocContext)
                    .add(UserEvent.userStarted(event.userId));
              },
              unauthenticated: (_) {
                AutoRouter.of(authenticationBlocContext)
                    .replace(const SignInPageRoute());
              },
            );
          },
        )
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          log("SplashPage user state #$state#");
          return Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MyText("data > < data"),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
