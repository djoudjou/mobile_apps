import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:familytrusts/src/presentation/sign_in/widgets/sign_in.dart';
import 'package:flutter/material.dart';

class SignInPage extends MyBasePage {
  SignInPage({super.key});

  @override
  Widget myBuild(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: MyAppBar(
        displayLogout: false,
        pageTitle: LocaleKeys.login_title.tr(),
        context: context,
      ),
      body: const SignInForm(),
    );
  }

  @override
  void refresh(BuildContext context) {
    // TODO: implement refresh
  }
}
