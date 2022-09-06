import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/date_helper.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/helper/validators.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart' as quiver;

class ChildPage extends StatefulWidget {
  final bool isEditing;
  final Child child;
  final String imageTag;
  final User connectedUser;

  const ChildPage({
    Key? key,
    required this.isEditing,
    required this.child,
    required this.imageTag,
    required this.connectedUser,
  }) : super(key: key);

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _firstname;
  String? _lastname;
  String? _imagePath;

  TextEditingController? dateCtl;

  bool get isEditing => widget.child.id != null;

  @override
  void initState() {
    super.initState();
    dateCtl = TextEditingController();
    dateCtl?.text = widget.child.birthday.toText;
  }

  @override
  void dispose() {
    dateCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ChildrenFormBloc(getIt<IFamilyRepository>()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: MyAppBar(
            context: context,
            pageTitle: LocaleKeys.child_title.tr(),
          ),
          body: BlocListener<ChildrenFormBloc, ChildrenFormState>(
            listener: (context, state) {
              state.map(
                addChildInProgress: (_) => showProgressMessage(
                  LocaleKeys.profile_addChildInProgress.tr(),
                  context,
                ),
                addChildSuccess: (_) => showSuccessMessage(
                  LocaleKeys.profile_addChildSuccess.tr(),
                  context,
                  onDismissed: () => AutoRouter.of(context).pop("Created"),
                ),
                addChildFailure: (_) => showErrorMessage(
                  LocaleKeys.profile_addChildFailure.tr(),
                  context,
                ),
                updateChildInProgress: (_) => showProgressMessage(
                  LocaleKeys.profile_updateChildInProgress.tr(),
                  context,
                ),
                updateChildSuccess: (_) => showSuccessMessage(
                  LocaleKeys.profile_updateChildSuccess.tr(),
                  context,
                  onDismissed: () => AutoRouter.of(context).pop("Updated"),
                ),
                updateChildFailure: (_) => showErrorMessage(
                  LocaleKeys.profile_updateChildFailure.tr(),
                  context,
                ),
                deleteChildInProgress: (_) => showProgressMessage(
                  LocaleKeys.profile_deleteChildInProgress.tr(),
                  context,
                ),
                deleteChildSuccess: (_) => showSuccessMessage(
                  LocaleKeys.profile_deleteChildSuccess.tr(),
                  context,
                  onDismissed: () => AutoRouter.of(context).pop("Updated"),
                ),
                deleteChildFailure: (_) => showErrorMessage(
                  LocaleKeys.profile_deleteChildFailure.tr(),
                  context,
                ),
                init: (_) {},
              );
            },
            child: Padding(
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
                          photoUrl: widget.child.photoUrl,
                          defaultImage: const Image(image: defaultChildImages),
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
                      initialValue: widget.child.firstName.getOrCrash(),
                      autofocus: !isEditing,
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
                      initialValue: widget.child.lastName.getOrCrash(),
                      autofocus: !isEditing,
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
                      autofocus: !isEditing,
                      style: textTheme.headline5,
                      keyboardType: TextInputType.datetime,
                      controller: dateCtl,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.form_birthday_label.tr(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return LocaleKeys.form_birthday_error.tr();
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        // Below line stops keyboard from appearing
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectBirthday();
                      },
                    ),
                    const MyVerticalSeparator(),
                    const MyVerticalSeparator(),
                    MyButton(
                      message: isEditing
                          ? LocaleKeys.global_update.tr()
                          : LocaleKeys.global_save.tr(),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final Child updatedChild = widget.child.copyWith(
                            firstName: FirstName(_firstname),
                            lastName: LastName(_lastname),
                            birthday: Birthday.fromValue(dateCtl?.text),
                          );
                          if (updatedChild.id == null) {
                            context.read<ChildrenFormBloc>().add(
                                  ChildrenFormEvent.addChild(
                                    child: updatedChild,
                                    user: widget.connectedUser,
                                    pickedFilePath: _imagePath,
                                  ),
                                );
                          } else {
                            context.read<ChildrenFormBloc>().add(
                                  ChildrenFormEvent.updateChild(
                                    child: updatedChild,
                                    user: widget.connectedUser,
                                    pickedFilePath: _imagePath,
                                  ),
                                );
                          }
                        }
                      },
                    ),
                    const MyVerticalSeparator(),
                    const MyVerticalSeparator(),
                    if (quiver.isNotBlank(widget.child.id)) ...[
                      MyButton(
                        message: LocaleKeys.global_delete.tr(),
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        onPressed: () async {
                          await AlertHelper().confirm(
                            context,
                            LocaleKeys.profile_deleteChildConfirm
                                .tr(args: [widget.child.displayName]),
                            onConfirmCallback: () {
                              context.read<ChildrenFormBloc>().add(
                                    ChildrenFormEvent.deleteChild(
                                      child: widget.child,
                                      user: widget.connectedUser,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectBirthday() async {
    final dartz.Option<DateTime> initialDate =
        (quiver.isNotBlank(dateCtl?.text))
            ? birthdayConverterToDate(dateCtl?.text)
            : dartz.some(DateTime.now());

    final DateTime? choice = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      context: context,
      initialDate: initialDate.toNullable()!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (choice != null) {
      setState(
        () {
          dateCtl?.text = birthdayConverterToString(choice);
        },
      );
    }
  }
}
