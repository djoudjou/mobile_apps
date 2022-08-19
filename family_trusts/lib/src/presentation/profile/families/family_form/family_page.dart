import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/form/bloc.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/family_form.dart';

typedef OnFamilySaveCallback = Function(Family updatedFamily);
typedef OnFamilyDeleteCallback = Function(Family familyToDelete);

class FamilyPage extends StatelessWidget with LogMixin {
  final User currentUser;
  final Family familyToEdit;

  const FamilyPage({
    Key? key,
    required this.familyToEdit,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FamilyFormBloc>(
          create: (context) => getIt<FamilyFormBloc>()
            ..add(FamilyFormEvent.init(currentUser.familyId, familyToEdit)),
        ),
      ],
      child: BlocConsumer<FamilyFormBloc, FamilyFormState>(
        listener: (context, state) {
          switch (state.state) {
            case FamilyFormStateEnum.none:
              break;
            case FamilyFormStateEnum.adding:
              showProgressMessage(
                LocaleKeys.profile_addFamilyInProgress
                    .tr(args: [state.name.getOrCrash()]),
                context,
              );
              break;
            case FamilyFormStateEnum.updating:
              showProgressMessage(
                LocaleKeys.profile_updateFamilyInProgress.tr(),
                context,
              );
              break;
            case FamilyFormStateEnum.deleting:
              showProgressMessage(
                LocaleKeys.profile_deleteFamilyInProgress.tr(),
                context,
              );
              break;
          }

          state.failureOrSuccessOption.fold(
            () => null,
            (result) {
              result.fold((failure) {
                showErrorMessage(
                  failure.map(
                    unexpected: (_) => LocaleKeys.global_unexpected.tr(),
                    insufficientPermission: (_) =>
                        LocaleKeys.global_insufficientPermission.tr(),
                    unableToUpdate: (_) =>
                        LocaleKeys.profile_updateFamilyFailure.tr(),
                    unableToCreate: (_) =>
                        LocaleKeys.profile_addFamilyFailure.tr(),
                    unableToDelete: (_) =>
                        LocaleKeys.profile_deleteFamilyFailure.tr(),
                    unknownFamily: (_) => LocaleKeys.profile_unknownFamily.tr(),
                  ),
                  context,
                );
              }, (success) {
                success.map(
                  updateSuccess: (_) => showSuccessMessage(
                    LocaleKeys.profile_updateFamilySuccess.tr(),
                    context,
                  ),
                  createSuccess: (_) => showSuccessMessage(
                    LocaleKeys.profile_addFamilySuccess.tr(),
                    context,
                    onDismissed: () => AutoRouter.of(context).pop(),
                  ),
                  deleteSucces: (_) => showSuccessMessage(
                    LocaleKeys.profile_deleteFamilySuccess.tr(),
                    context,
                    onDismissed: () => AutoRouter.of(context).pop(),
                  ),
                );
              });
            },
          );
        },
        builder: (context, state) => Scaffold(
          appBar: MyAppBar(
            pageTitle: LocaleKeys.family_title.tr(),
            context: context,
          ),
          body: Center(
            child: FamilyForm(currentUser: currentUser),
          ),
        ),
      ),
    );
  }
}
