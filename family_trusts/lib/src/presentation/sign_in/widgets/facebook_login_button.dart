import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_buttons/auth_buttons.dart' show FacebookAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;

class FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FacebookAuthButton(
      style: const AuthButtonStyle(
        buttonType: AuthButtonType.secondary,
        iconType: AuthIconType.outlined,
      ),
      text: LocaleKeys.login_facebook.tr(),
      onPressed: () {
        context
            .read<SignInFormBloc>()
            .add(const SignInFormEvent.signInWithFacebookPressed());
      },
    );
  }
}
