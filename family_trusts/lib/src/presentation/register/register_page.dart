import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/register/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:familytrusts/src/presentation/register/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends MyBasePage {
  @override
  Widget myBuild(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        pageTitle: LocaleKeys.register_title.tr(),
        context: context,
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            getIt<IUserRepository>(),
            getIt<IAuthFacade>(),
          )..add(const RegisterEvent.init()),
          child: RegisterForm(),
        ),
      ),
    );
  }

  @override
  void refresh(BuildContext context) {
    // TODO: implement refresh
  }
}
