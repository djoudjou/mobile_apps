import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(LocaleKeys.login_register_msg.tr()),
        TextButton(
          style: flatButtonStyle,
          onPressed: () {
            AutoRouter.of(context).replace(
              RegisterPageRoute(
                key: const ValueKey("RegisterPage"),
              ),
            );
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
