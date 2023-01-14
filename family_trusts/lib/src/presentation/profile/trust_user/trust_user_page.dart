import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/helper/validators.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrustUserPage extends StatefulWidget {
  final TrustedUser trustedUserToEdit;
  final User connectedUser;
  final String imageTag;

  const TrustUserPage({
    super.key,
    required this.trustedUserToEdit,
    required this.imageTag,
    required this.connectedUser,
  });

  @override
  State<TrustUserPage> createState() => _TrustUserPageState();
}

class _TrustUserPageState extends State<TrustUserPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _lastname;
  String? _firstname;
  String? _phoneNumber;
  String? _email;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: MyAppBar(
        pageTitle: LocaleKeys.profile_tabs_trusted_tab.tr(),
        context: context,
      ),
      body: BlocProvider<TrustedUserFormBloc>(
        create: (context) => TrustedUserFormBloc(
          getIt<IFamilyRepository>(),
          getIt<AnalyticsSvc>(),
        )..add(
            TrustedUserFormEvent.init(
              connectedUser: widget.connectedUser,
              toEdit: widget.trustedUserToEdit,
            ),
          ),
        child: BlocConsumer<TrustedUserFormBloc, TrustedUserFormState>(
          listener: (contextTrustedUserFormBloc, state) {
            switch (state.status) {
              case TrustedUserFormStateEnum.removing:
                showProgressMessage(
                  LocaleKeys.profile_deleteTrustedUserInProgress.tr(),
                  contextTrustedUserFormBloc,
                );
                break;
              case TrustedUserFormStateEnum.submiting:
                showProgressMessage(
                  LocaleKeys.profile_addTrustedUserInProgress.tr(),
                  contextTrustedUserFormBloc,
                );
                break;
              default:
                break;
            }

            state.submitTrustedUserFailureOrSuccessOption.fold(
              () => null,
              (value) => value.fold(
                (failure) {
                  showErrorMessage(
                    LocaleKeys.profile_addTrustedUserFailure.tr(),
                    contextTrustedUserFormBloc,
                  );
                },
                (success) {
                  showSuccessMessage(
                    LocaleKeys.profile_addTrustedUserSuccess.tr(),
                    context,
                    onDismissed: () => AutoRouter.of(contextTrustedUserFormBloc)
                        .pop("Created"),
                  );
                },
              ),
            );

            state.removeTrustedUserFailureOrSuccessOption.fold(
              () => null,
              (value) => value.fold(
                (failure) {
                  showErrorMessage(
                    LocaleKeys.profile_deleteTrustedUserFailure.tr(),
                    contextTrustedUserFormBloc,
                  );
                },
                (success) {
                  showSuccessMessage(
                    LocaleKeys.profile_deleteTrustedUserSuccess.tr(),
                    context,
                    onDismissed: () => AutoRouter.of(contextTrustedUserFormBloc)
                        .pop("Deleted"),
                  );
                },
              ),
            );
          },
          builder: (contextTrustedUserFormBloc, state) {
            if (state.status == TrustedUserFormStateEnum.initializing) {
              return const LoadingContent();
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: ProfileImage(
                          imageTag: widget.imageTag,
                          editable: true,
                          image: MyImage(
                            imagePath: _imagePath,
                            photoUrl: widget.trustedUserToEdit.photoUrl,
                            defaultImage: const Image(image: defaultUserImages),
                          ),
                          radius: 70,
                          onUpdatePictureFilePathCallback:
                              (context, pickedFilePath) {
                            setState(() {
                              _imagePath = pickedFilePath;
                            });
                          },
                        ),
                      ),
                      const MyVerticalSeparator(),
                      TextFormField(
                        initialValue:
                            widget.trustedUserToEdit.firstName.value.fold((l) => "", (r) => r),
                        enabled: true,
                        style: textTheme.headline5,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.form_firstname_label.tr(),
                        ),
                        validator: (val) {
                          return !Validators().isValidFirstName(val)
                              ? LocaleKeys.form_firstname_error.tr()
                              : null;
                        },
                        onSaved: (value) => _firstname = value,
                      ),
                      const MyVerticalSeparator(),
                      TextFormField(
                        initialValue:
                            widget.trustedUserToEdit.lastName.value.fold((l) => "", (r) => r),
                        enabled: true,
                        style: textTheme.headline5,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.form_lastname_label.tr(),
                        ),
                        validator: (val) {
                          return !Validators().isValidLastName(val)
                              ? LocaleKeys.form_lastname_error.tr()
                              : null;
                        },
                        onSaved: (value) => _lastname = value,
                      ),
                      const MyVerticalSeparator(),
                      TextFormField(
                        initialValue:
                            widget.trustedUserToEdit.email.value.fold((l) => "", (r) => r),
                        //autofocus: !state.submitUserEnable!,
                        enabled: true,
                        style: textTheme.headline5,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.form_email_label.tr(),
                        ),
                        validator: (val) {
                          return !Validators().isValidEmail(val)
                              ? LocaleKeys.form_email_error.tr()
                              : null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                      const MyVerticalSeparator(),
                      TextFormField(
                        initialValue:
                            widget.trustedUserToEdit.phoneNumber.value.fold((l) => "", (r) => r),
                        //autofocus: !state.submitUserEnable!,
                        enabled: true,
                        style: textTheme.headline5,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.form_phone_label.tr(),
                        ),
                        validator: (val) {
                          return !Validators().isValidPhone(val)
                              ? LocaleKeys.form_phone_error.tr()
                              : null;
                        },
                        onSaved: (value) => _phoneNumber = value,
                      ),
                      const MyVerticalSeparator(),
                      Container(margin: const EdgeInsets.only(top: 25.0)),
                      MyButton(
                        message: LocaleKeys.user_update.tr(),
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final TrustedUser updatedTrustUser =
                                widget.trustedUserToEdit.copyWith(
                              phoneNumber: PhoneNumber(_phoneNumber),
                              firstName: FirstName(_firstname),
                              lastName: LastName(_lastname),
                              email: EmailAddress(_email),
                            );
                            contextTrustedUserFormBloc
                                .read<TrustedUserFormBloc>()
                                .add(
                                  TrustedUserFormEvent.submitted(
                                    trustedUser: updatedTrustUser,
                                    connectedUser: widget.connectedUser,
                                    pickedFilePath: _imagePath,
                                  ),
                                );
                            //Navigator.pop(context);
                          }
                        },
                      ),
                      const MyVerticalSeparator(),
                      if (state.deleteEnable) ...[
                        Container(margin: const EdgeInsets.only(top: 25.0)),
                        MyButton(
                          message: LocaleKeys.trust_user_disconnect.tr(),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            AlertHelper().confirm(
                              context,
                              LocaleKeys.trust_user_disconnect_confirm.tr(
                                args: [widget.trustedUserToEdit.displayName],
                              ),
                              onConfirmCallback: () {
                                contextTrustedUserFormBloc
                                    .read<TrustedUserFormBloc>()
                                    .add(
                                      TrustedUserFormEvent.removeTrustedUser(
                                        trustedUserId:
                                            widget.trustedUserToEdit.id!,
                                        familyId:
                                            widget.connectedUser.family!.id!,
                                      ),
                                    );
                                //widget.onDisconnectCallback(widget.user);
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
