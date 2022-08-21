import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/sign_in/widgets/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget with LogMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInFormBloc(
            getIt<IAuthFacade>(),
            getIt<AnalyticsSvc>(),
          ),
        ),
      ],
      child: BlocConsumer<SignInFormBloc, SignInFormState>(
        listener: (blocContext, state) {
          log("signin form > debug signin #$state#");
          state.authFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (failure) {
                showErrorMessage(
                  failure.map(
                    cancelledByUser: (_) =>
                        LocaleKeys.login_cancelledByUser.tr(),
                    serverError: (_) => LocaleKeys.global_serverError.tr(),
                    emailAlreadyInUse: (_) =>
                        LocaleKeys.login_emailAlreadyInUse.tr(),
                    invalidEmailAndPasswordCombination: (_) => LocaleKeys
                        .login_invalidEmailAndPasswordCombination
                        .tr(),
                    alreadySignWithAnotherMethod: (e) => LocaleKeys
                        .register_alreadySignedWithAnotherMethod
                        .tr(args: [e.providerName]),
                  ),
                  blocContext,
                );
              },
              (userId) {
                BlocProvider.of<UserBloc>(blocContext).add(UserEvent.userStarted(userId));
              },
            ),
          );
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(logoImagesPath, height: 200),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: LocaleKeys.form_email_label.tr(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    onChanged: (value) => context
                        .read<SignInFormBloc>()
                        .add(SignInFormEvent.emailChanged(value)),
                    validator: (_) => context
                        .read<SignInFormBloc>()
                        .state
                        .emailAddress
                        .value
                        .fold(
                          (f) => f.maybeMap(
                            invalidEmail: (_) =>
                                LocaleKeys.form_email_error.tr(),
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
                  ),
                  const MyVerticalSeparator(),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: LocaleKeys.form_password_label.tr(),
                    ),
                    obscureText: true,
                    autocorrect: false,
                    onChanged: (value) => context
                        .read<SignInFormBloc>()
                        .add(SignInFormEvent.passwordChanged(value)),
                    validator: (_) => context
                        .watch<SignInFormBloc>()
                        .state
                        .password
                        .value
                        .fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) =>
                                LocaleKeys.form_password_error.tr(),
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MyButton(
                          message: LocaleKeys.login_proceed.tr(),
                          onPressed: () {
                            context.read<SignInFormBloc>().add(
                                  const SignInFormEvent
                                      .signInWithEmailAndPasswordPressed(),
                                );
                          },
                        ),
                        const MyVerticalSeparator(),
                        MyText(LocaleKeys.login_or.tr()),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GoogleLoginButton(),
                              //const MyHorizontalSeparator(),
                              FacebookLoginButton(),
                            ],
                          ),
                        ),
                        const MyVerticalSeparator(),
                        CreateAccountButton(),
                      ],
                    ),
                  ),
                  if (state.isSubmitting) ...[
                    const MyVerticalSeparator(),
                    const LinearProgressIndicator(),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
