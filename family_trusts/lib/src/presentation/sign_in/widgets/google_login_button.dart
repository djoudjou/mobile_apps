import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/bloc.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart' show GoogleAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleAuthButton(
      style: const AuthButtonStyle(
        buttonType: AuthButtonType.secondary,
        iconType: AuthIconType.secondary,
      ),
      text: LocaleKeys.login_google.tr(),
      onPressed: () {
        context
            .read<SignInFormBloc>()
            .add(const SignInFormEvent.signInWithGooglePressed());
      },
      darkMode: true, // default: false
    );
  }
}
