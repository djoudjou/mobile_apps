import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/register/bloc.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/register/widgets/register_form.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        pageTitle: LocaleKeys.register_title.tr(),
        context: context,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              state.map(
                initial: (_) {},
                authenticated: (_) {},
                unauthenticated: (_) =>
                    context.replaceRoute(const SignInPageRoute()),
                //ExtendedNavigator.of(context).replace(Routes.signInPage),
              );
            },
          ),
        ],
        child: Center(
          child: BlocProvider<RegisterBloc>(
            create: (context) =>
                getIt<RegisterBloc>()..add(const RegisterEvent.init()),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
