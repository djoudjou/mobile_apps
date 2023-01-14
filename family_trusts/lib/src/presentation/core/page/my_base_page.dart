import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/connection/connection_bloc.dart';
import 'package:familytrusts/src/application/connection/connection_event.dart';
import 'package:familytrusts/src/application/connection/connection_state.dart';
import 'package:familytrusts/src/application/home/user/user_bloc.dart';
import 'package:familytrusts/src/application/home/user/user_event.dart';
import 'package:familytrusts/src/application/home/user/user_state.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyBasePage extends StatelessWidget with LogMixin {
  MyBasePage({
    super.key,
  });

  Widget myBuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    context.read<ConnectBloc>().add(const ConnectEvent.init());
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectBloc, ConnectState>(
          listener: (connectBlocCtx, state) {
            log("ConnectState state #$state#");
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (userBlocContext, state) {
            log("MyBasePage user state #$state#");
            if (state is UserLoadFailure) {
              showErrorMessage(
                LocaleKeys.global_serverError.tr(),
                context,
                onDismissed: () {
                  AutoRouter.of(userBlocContext).replace(SignInPageRoute(
                    key: const ValueKey("SignInPage"),
                  ));
                },
              );
            } else if (state is UserLoadSuccess) {
              final User user = state.user;

              if (user.notInFamily()) {
                // navigation vers
                AutoRouter.of(userBlocContext).replace(
                  HomePageWithoutFamilyRoute(
                    key: const ValueKey("HomePageWithoutFamily"),
                    connectedUser: user,
                  ),
                );
              } else {
                AutoRouter.of(userBlocContext).replace(
                  HomePageRoute(
                    key: const ValueKey("HomePage"),
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
            if (state is Unauthenticated) {
              log("===> logouted <===");
              AutoRouter.of(authenticationBlocContext).replace(SignInPageRoute(
                key: const ValueKey("SignInPage"),
              ));
            }
            if (state is Authenticated) {
              log("===> login <===");
              authenticationBlocContext
                  .read<UserBloc>()
                  .add(UserEvent.userStarted(state.userId));
            }
          },
        ),
      ],
      child: myBuild(context),
    );
  }

  void refresh(BuildContext context);
}
