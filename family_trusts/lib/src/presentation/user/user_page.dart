import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/user_form/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/helper/validators.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatefulWidget {
  final User userToEdit;
  final User connectedUser;
  final String imageTag;

  const UserPage({
    super.key,
    required this.userToEdit,
    required this.imageTag,
    required this.connectedUser,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _lastname;
  String? _firstname;
  String? _email;
  String? _imagePath;

  //LocationResult _pickedLocation;

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
        pageTitle: LocaleKeys.user_title.tr(),
        context: context,
      ),
      body: BlocProvider<UserFormBloc>(
        create: (context) => UserFormBloc(
          getIt<IUserRepository>(),
          getIt<IFamilyRepository>(),
          getIt<AnalyticsSvc>(),
        )..add(
            UserFormEvent.init(
              connectedUser: widget.connectedUser,
              userToEdit: widget.userToEdit,
            ),
          ),
        child: BlocConsumer<UserFormBloc, UserFormState>(
          listener: (context, state) {
            switch (state.status) {
              case UserFormStateEnum.unTrusting:
                showProgressMessage(
                  LocaleKeys.profile_deleteTrustedUserInProgress.tr(),
                  context,
                );
                break;
              case UserFormStateEnum.submiting:
                showProgressMessage(
                  LocaleKeys.global_update.tr(),
                  context,
                );
                break;
              default:
                break;
            }

            if (state.submitUserFailureOrSuccessOption.isSome()) {
              state.submitUserFailureOrSuccessOption.toNullable()!.fold(
                (failure) {
                  showErrorMessage(
                    LocaleKeys.global_unexpected.tr(),
                    context,
                  );
                },
                (success) {
                  showSuccessMessage(
                    LocaleKeys.global_success.tr(),
                    context,
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state.status == UserFormStateEnum.initializing) {
              return const CircularProgressIndicator();
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
                          editable: state.submitUserEnable!,
                          image: MyImage(
                            imagePath: _imagePath,
                            photoUrl: widget.userToEdit.photoUrl,
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
                        initialValue: widget.userToEdit.firstName.getOrCrash(),
                        autofocus: !state.submitUserEnable!,
                        enabled: state.submitUserEnable,
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
                        initialValue: widget.userToEdit.lastName.getOrCrash(),
                        autofocus: !state.submitUserEnable!,
                        enabled: state.submitUserEnable,
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
                        initialValue: widget.userToEdit.email.getOrCrash(),
                        //autofocus: !state.submitUserEnable!,
                        enabled: false,
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
                      if (state.submitUserEnable!) ...[
                        Container(margin: const EdgeInsets.only(top: 25.0)),
                        MyButton(
                          message: LocaleKeys.user_update.tr(),
                          onPressed: () {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final User updatedUser =
                                  widget.userToEdit.copyWith(
                                firstName: FirstName(_firstname),
                                lastName: LastName(_lastname),
                                email: EmailAddress(_email),
                              );
                              //widget.onSaveCallback(updatedUser, _imagePath);
                              context.read<UserFormBloc>().add(
                                    UserFormEvent.userSubmitted(
                                      user: updatedUser,
                                      connectedUser: widget.connectedUser,
                                      pickedFilePath: _imagePath,
                                    ),
                                  );
                              //Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                      const MyVerticalSeparator(),
                      if (state.disconnectUserEnable!) ...[
                        Container(margin: const EdgeInsets.only(top: 25.0)),
                        MyButton(
                          message: LocaleKeys.user_disconnect.tr(),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            AlertHelper().confirm(
                              context,
                              LocaleKeys.user_disconnect_confirm.tr(
                                args: [widget.userToEdit.displayName],
                              ),
                              onConfirmCallback: () {
                                context.read<UserFormBloc>().add(
                                      UserFormEvent.leaveFamily(
                                        connectedUser: widget.connectedUser,
                                        family: widget.connectedUser.family!,
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
