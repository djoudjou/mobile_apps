import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(LocaleKeys.login_register_msg.tr()),
        TextButton(
          style: flatButtonStyle,
          onPressed: () {
            context.pushRoute(const RegisterPageRoute());
          },
          child: MyText(
            LocaleKeys.login_register.tr(),
            style: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
