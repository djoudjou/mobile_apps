import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/location/watcher/bloc.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/avatar_widget.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileLocations extends StatelessWidget {
  final double radius;
  final User connectedUser;
  final _key = const PageStorageKey<String>('locations');

  ProfileLocations({
    Key? key,
    required this.radius,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationsBloc>(
      create: (BuildContext context) => getIt<LocationsBloc>()
        ..add(LocationsEvent.loadLocations(connectedUser.familyId)),
      child: Builder(
        builder: (context) => MultiBlocListener(
          listeners: [
            BlocListener<LocationsBloc, LocationsState>(
              listener: (context, state) {
                state.map(
                  loading: (_) {},
                  locationsLoaded: (_) {},
                  locationsNotLoaded: (_) => showErrorMessage(
                    LocaleKeys.profile_locationsNotLoaded.tr(),
                    context,
                  ),
                );
              },
            ),
          ],
          child: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (locationsBlocContext, state) {
              return state.maybeMap(
                orElse: () => Column(
                  children: <Widget>[
                    MyText(LocaleKeys.profile_tabs_locations_loading.tr()),
                    const LoadingContent(),
                  ],
                ),
                locationsNotLoaded: (trustedUsersNotLoaded) => Container(
                  color: Colors.blue,
                  child: MyText(LocaleKeys.profile_tabs_locations_error.tr()),
                ),
                locationsLoaded: (locationsLoaded) =>
                    locationsLoaded.locations.fold(
                  (locationFailure) => Center(
                    child: Container(
                      //color: Colors.blue,
                      child:
                          MyText(LocaleKeys.profile_tabs_locations_error.tr()),
                    ),
                  ),
                  (locations) => locations.isEmpty
                      ? Align(
                          child: MyText(
                            LocaleKeys.profile_tabs_locations_noPlaces.tr(),
                            maxLines: 3,
                          ),
                        )
                      : ListView.separated(
                          key: _key,
                          padding: const EdgeInsets.all(8),
                          itemCount: locations.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            final Either<LocationFailure, Location>
                                eitherLocation = locations[index];
                            return eitherLocation.fold(
                              (locationFailure) => const SizedBox(height: 0),
                              (location) => Container(
                                //color: Colors.red,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: MyAvatar(
                                        imageTag:
                                            "LOCATION_IMAGE_TAG_${location.id}",
                                        photoUrl: location.photoUrl,
                                        radius: radius / 2,
                                        onTapCallback: () => gotoEditLocation(
                                            context, location, connectedUser),
                                        defaultImage: defaultLocationImages,
                                      ),
                                    ),
                                    const MyHorizontalSeparator(),
                                    InkWell(
                                      onTap: () => gotoEditLocation(
                                        context,
                                        location,
                                        connectedUser,
                                      ),
                                      child:
                                          MyText(location.title.getOrCrash()),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void gotoEditLocation(
    BuildContext context, Location location, User currentUser) {
  AutoRouter.of(context).push(
      LocationPageRoute(locationToEdit: location, currentUser: currentUser));
}
