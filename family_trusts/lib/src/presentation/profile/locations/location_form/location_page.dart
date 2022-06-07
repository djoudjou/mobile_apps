import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/location/form/bloc.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/location_form.dart';

typedef OnLocationSaveCallback = Function(
  Location updatedLocation,
  String pickedFilePath,
);
typedef OnLocationDeleteCallback = Function(Location locationToDelete);

class LocationPage extends StatelessWidget with LogMixin {
  final User currentUser;
  final Location locationToEdit;

  const LocationPage({
    Key? key,
    required this.locationToEdit,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationFormBloc>(
          create: (context) => getIt<LocationFormBloc>()
            ..add(LocationFormEvent.init(currentUser.familyId, locationToEdit)),
        ),
      ],
      child: BlocConsumer<LocationFormBloc, LocationFormState>(
        listener: (context, state) {
          switch (state.state) {
            case LocationFormStateEnum.none:
              break;
            case LocationFormStateEnum.adding:
              showProgressMessage(
                LocaleKeys.profile_addLocationInProgress.tr(),
                context,
              );
              break;
            case LocationFormStateEnum.updating:
              showProgressMessage(
                LocaleKeys.profile_updateLocationInProgress.tr(),
                context,
              );
              break;
            case LocationFormStateEnum.deleting:
              showProgressMessage(
                LocaleKeys.profile_deleteLocationInProgress.tr(),
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
                          LocaleKeys.profile_updateLocationFailure.tr(),
                      unableToCreate: (_) =>
                          LocaleKeys.profile_addLocationFailure.tr(),
                      unableToDelete: (_) =>
                          LocaleKeys.profile_deleteLocationFailure.tr(),
                    ),
                    context);
              }, (success) {
                success.map(
                  updateSuccess: (_) => showSuccessMessage(
                      LocaleKeys.profile_updateLocationSuccess.tr(), context),
                  createSuccess: (_) => showSuccessMessage(
                    LocaleKeys.profile_addLocationSuccess.tr(),
                    context,
                    onDismissed: () => AutoRouter.of(context).pop(),
                  ),
                  deleteSucces: (_) => showSuccessMessage(
                    LocaleKeys.profile_deleteLocationSuccess.tr(),
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
            pageTitle: LocaleKeys.location_title.tr(),
            context: context,
          ),
          body: Center(
            child: LocationForm(currentUser: currentUser),
          ),
        ),
      ),
    );
  }
}
