import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/auth/authentication_bloc.dart';
import 'package:familytrusts/src/application/auth/authentication_event.dart';
import 'package:familytrusts/src/application/register/bloc.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  //static const parisLocation = ;
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        state.registerFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              showErrorMessage(
                failure.map(
                  cancelledByUser: (_) =>
                      LocaleKeys.register_cancelledByUser.tr(),
                  serverError: (_) => LocaleKeys.global_serverError.tr(),
                  emailAlreadyInUse: (_) =>
                      LocaleKeys.register_emailAlreadyInUse.tr(),
                  alreadySignWithAnotherMethod: (e) => LocaleKeys
                      .register_alreadySignedWithAnotherMethod
                      .tr(args: [e.providerName]),
                ),
                context,
              );
            },
            (userId) {
              //showSuccessMessage(
              //  "Success $userId",
              //  context,
              //);

              context.replaceRoute(
                HomePageRoute(
                  currentTab: AppTab.ask,
                  connectedUserId: userId!,
                ),
              );
              //ExtendedNavigator.of(context).pushAndRemoveUntil(
              //  Routes.homePage,
              //  (route) => false,
              //);
              context
                  .read<AuthenticationBloc>()
                  .add(const AuthenticationEvent.authCheckRequested());
            },
          ),
        );
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state.isInitializing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                autovalidateMode: state.showErrorMessages
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: ProfileImage(
                        imageTag: "REGISTER_IMAGE_TAG",
                        editable: true,
                        image: MyImage(
                          imagePath: state.imagePath,
                          photoUrl: state.photoUrl,
                          defaultImage: const Image(image: defaultChildImages),
                        ),
                        radius: 70,
                        onUpdatePictureFilePathCallback:
                            (context, pickedFilePath) {
                          context.read<RegisterBloc>().add(
                                RegisterEvent.registerPictureChanged(
                                  pickedFilePath,
                                ),
                              );
                        },
                      ),
                    ),
                    const MyVerticalSeparator(),
                    email(state, context),
                    if (state.isEditEmailPwdEnabled) ...[
                      const MyVerticalSeparator(),
                      password(state, context),
                    ],
                    const MyVerticalSeparator(),
                    surname(state, context),
                    const MyVerticalSeparator(),
                    name(state, context),
                    const MyVerticalSeparator(),
                    MyButton(
                      message: LocaleKeys.register_proceed.tr(),
                      onPressed: () => context
                          .read<RegisterBloc>()
                          .add(const RegisterEvent.registerSubmitted()),
                    ),
                    if (state.isSubmitting) ...[
                      const MyVerticalSeparator(),
                      const LinearProgressIndicator(),
                    ]
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget password(RegisterState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: const Icon(Icons.lock),
        labelText: LocaleKeys.form_password_label.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      obscureText: true,
      onChanged: (value) => context
          .read<RegisterBloc>()
          .add(RegisterEvent.registerPasswordChanged(value)),
      validator: (_) => context.read<RegisterBloc>().state.password.value.fold(
            (f) => f.maybeMap(
              shortPassword: (_) => LocaleKeys.form_password_error.tr(),
              orElse: () => null,
            ),
            (_) => null,
          ),
    );
  }

  Widget email(RegisterState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        labelText: LocaleKeys.form_email_label.tr(),
      ),
      initialValue:
          !state.isEditEmailPwdEnabled ? state.emailAddress.getOrCrash() : '',
      keyboardType: TextInputType.emailAddress,
      enabled: state.isEditEmailPwdEnabled,
      autocorrect: false,
      onChanged: (value) => context
          .read<RegisterBloc>()
          .add(RegisterEvent.registerEmailChanged(value)),
      validator: (_) =>
          context.read<RegisterBloc>().state.emailAddress.value.fold(
                (f) => f.maybeMap(
                  invalidEmail: (_) => LocaleKeys.form_email_error.tr(),
                  orElse: () => null,
                ),
                (_) => null,
              ),
    );
  }

  Widget surname(RegisterState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.form_surname_label.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context
          .read<RegisterBloc>()
          .add(RegisterEvent.registerSurnameChanged(value)),
      validator: (_) => context.read<RegisterBloc>().state.surname.value.fold(
            (f) => f.maybeMap(
              empty: (_) => LocaleKeys.form_surname_error.tr(),
              orElse: () => null,
            ),
            (_) => null,
          ),
    );
  }

  Widget name(RegisterState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.form_name_label.tr(),
      ),
      keyboardType: TextInputType.text,
      autocorrect: false,
      onChanged: (value) => context
          .read<RegisterBloc>()
          .add(RegisterEvent.registerNameChanged(value)),
      validator: (_) => context.read<RegisterBloc>().state.name.value.fold(
            (f) => f.maybeMap(
              empty: (_) => LocaleKeys.form_name_error.tr(),
              orElse: () => null,
            ),
            (_) => null,
          ),
    );
  }
}
