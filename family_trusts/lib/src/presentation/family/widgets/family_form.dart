import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/form/bloc.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart' as quiver;

class FamilyForm extends StatefulWidget {
  final User currentUser;

  const FamilyForm({
    super.key,
    required this.currentUser,
  });

  @override
  State<FamilyForm> createState() => _FamilyFormState();
}

class _FamilyFormState extends State<FamilyForm> with LogMixin {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyFormBloc, FamilyFormState>(
      listenWhen: (beforeState, afterState) =>
          beforeState.isInitializing && afterState.isInitializing == false,
      listener: (context, state) {
        _nameController.text = state.name.value.toOption().toNullable() ?? '';
      },
      child: BlocConsumer<FamilyFormBloc, FamilyFormState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isInitializing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                autovalidateMode: state.showErrorMessages
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(logoFamilyImagesPath, height: 200),
                    ),
                    const MyVerticalSeparator(),
                    const MyVerticalSeparator(),
                    TextFormField(
                      decoration: InputDecoration(
                        //icon: const Icon(Icons.abc),
                        labelText: LocaleKeys.family_form_name_label.tr(),
                      ),
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<FamilyFormBloc>()
                          .add(FamilyFormEvent.nameChanged(value)),
                      validator: (_) =>
                          context.read<FamilyFormBloc>().state.name.value.fold(
                                (f) => f.maybeMap(
                                  orElse: () =>
                                      LocaleKeys.family_form_name_error.tr(),
                                ),
                                (_) => null,
                              ),
                    ),
                    const MyVerticalSeparator(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MyButton(
                            //backgroundColor: Colors.blue,
                            message: quiver.isBlank(state.id)
                                ? LocaleKeys.global_save.tr()
                                : LocaleKeys.global_update.tr(),
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final updatedFamily = Family(
                                  id: state.id,
                                  name: state.name,
                                );
                                onSaveCallback(
                                  context,
                                  updatedFamily,
                                  widget.currentUser,
                                );
                              }
                            },
                          ),
                          if (quiver.isNotBlank(state.id)) ...[
                            MyButton(
                              backgroundColor: Colors.red,
                              message: LocaleKeys.global_delete.tr(),
                              onPressed: () {
                                final deletedFamily = Family(
                                  id: state.id,
                                  name: state.name,
                                );
                                onDeleteCallback(
                                  context,
                                  deletedFamily,
                                  widget.currentUser,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                    if (state.state != FamilyFormStateEnum.none) ...[
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

  void onSaveCallback(
    BuildContext context,
    Family updatedFamily,
    User connectedUser,
  ) {
    final FamilyFormBloc bloc = context.read<FamilyFormBloc>();
    log("> update family $updatedFamily");

    bloc.add(
      FamilyFormEvent.saveFamily(
        connectedUser: connectedUser,
        family: updatedFamily,
      ),
    );
  }

  Future<void> onDeleteCallback(
    BuildContext context,
    Family familyToDelete,
    User connectedUser,
  ) async {
    await AlertHelper().confirm(
      context,
      LocaleKeys.profile_deleteFamilyConfirm
          .tr(args: [familyToDelete.name.value.getOrElse(() => '')]),
      onConfirmCallback: () {
        final FamilyFormBloc familyFormBloc = context.read<FamilyFormBloc>();
        log(" delete family $familyToDelete");

        familyFormBloc.add(
          FamilyFormEvent.deleteFamily(
            connectedUser: connectedUser,
            family: familyToDelete,
          ),
        );
        AutoRouter.of(context).pop();
      },
    );
  }
}
