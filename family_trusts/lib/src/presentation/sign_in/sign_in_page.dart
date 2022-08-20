import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:familytrusts/src/presentation/sign_in/widgets/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget with LogMixin {
  const SignInPage({Key? key}) : super(key: key);

  //
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInFormBloc>(
          create: (context) =>
              SignInFormBloc(getIt<IAuthFacade>(), getIt<AnalyticsSvc>()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (userBlocContext, state) {
              if (state is UserLoadSuccess) {
                BlocProvider.of<AuthenticationBloc>(userBlocContext)
                    .add(const AuthenticationEvent.authCheckRequested());

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
        ],
        child: Scaffold(
          key: GlobalKey<ScaffoldState>(),
          appBar: MyAppBar(
            displayLogout: false,
            pageTitle: LocaleKeys.login_title.tr(),
            context: context,
          ),
          body: SignInForm(),
        ),
      ),
    );
  }
}
