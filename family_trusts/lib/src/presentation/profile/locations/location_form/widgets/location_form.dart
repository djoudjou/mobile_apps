import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/location/form/bloc.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_button.dart';
import 'package:familytrusts/src/presentation/core/my_image.dart';
import 'package:familytrusts/src/presentation/core/separator.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_image.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quiver/strings.dart' as quiver;

class LocationForm extends StatefulWidget {
  final User currentUser;

  const LocationForm({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> with LogMixin {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void dispose() {
    _disposeController();
    _titleController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationFormBloc, LocationFormState>(
      listenWhen: (beforeState, afterState) =>
          beforeState.isInitializing && afterState.isInitializing == false,
      listener: (context, state) {
        _titleController.text = state.title.value.toOption().toNullable() ?? '';
        _addressController.text =
            state.address.value.toOption().toNullable() ?? '';
        _noteController.text = state.note.value.toOption().toNullable() ?? '';
      },
      child: BlocConsumer<LocationFormBloc, LocationFormState>(
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
                    buildLocationLogo(state),
                    const MyVerticalSeparator(),
                    //buildMap(state, context),
                    //const MySeparator(),
                    /*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectPlacePickerInput(
                        currentPosition: state.currentPosition.getOrCrash(),
                        onSelectPlaceCallback: (params) {
                          context.read<LocationFormBloc>().add(
                              LocationFormEvent.addressChanged(params.address));
                          context.read<LocationFormBloc>().add(
                              LocationFormEvent.latLngChanged(params.position));
                        },
                      ),
                    ),
                     */
                    const MyVerticalSeparator(),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.title),
                        labelText: LocaleKeys.location_form_title_label.tr(),
                      ),
                      controller: _titleController,
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<LocationFormBloc>()
                          .add(LocationFormEvent.titleChanged(value)),
                      validator: (_) => context
                          .read<LocationFormBloc>()
                          .state
                          .title
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              orElse: () =>
                                  LocaleKeys.location_form_title_error.tr(),
                            ),
                            (_) => null,
                          ),
                    ),
                    const MyVerticalSeparator(),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email),
                        labelText: LocaleKeys.location_form_address_label.tr(),
                      ),
                      controller: _addressController,
                      keyboardType: TextInputType.name,
                      maxLines: 2,
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<LocationFormBloc>()
                          .add(LocationFormEvent.addressChanged(value)),
                      onTap: () {
                        // Below line stops keyboard from appearing
                        FocusScope.of(context).requestFocus(FocusNode());

                        context.pushRoute(
                          SearchAddressPageRoute(
                              onSelectAddressCallback: (complexAddress) {
                            _addressController.text = complexAddress.address!;
                            context.read<LocationFormBloc>().add(
                                LocationFormEvent.addressChanged(
                                    complexAddress.address!));
                            context.read<LocationFormBloc>().add(
                                LocationFormEvent.latLngChanged(
                                    complexAddress.position!));

                            context.popRoute();
                            //ExtendedNavigator.of(context).pop();
                          }),
                        );
                      },
                      validator: (_) => context
                          .read<LocationFormBloc>()
                          .state
                          .address
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              orElse: () =>
                                  LocaleKeys.location_form_address_error.tr(),
                            ),
                            (_) => null,
                          ),
                    ),
                    const MyVerticalSeparator(),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.note),
                        labelText: LocaleKeys.location_form_note_label.tr(),
                      ),
                      controller: _noteController,
                      keyboardType: TextInputType.name,
                      maxLines: 2,
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<LocationFormBloc>()
                          .add(LocationFormEvent.noteChanged(value)),
                      validator: (_) => context
                          .read<LocationFormBloc>()
                          .state
                          .note
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              orElse: () =>
                                  LocaleKeys.location_form_note_error.tr(),
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
                            //backgroundColor: Colors.blue,
                            message: quiver.isBlank(state.id)
                                ? LocaleKeys.global_save.tr()
                                : LocaleKeys.global_update.tr(),
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final updatedLocation = Location(
                                  id: state.id,
                                  address: state.address,
                                  title: state.title,
                                  note: state.note,
                                  gpsPosition: state.gpsPosition,
                                  photoUrl: state.photoUrl,
                                );
                                onSaveCallback(
                                  context,
                                  updatedLocation,
                                  state.imagePath,
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
                                final deletedLocation = Location(
                                  id: state.id,
                                  address: state.address,
                                  title: state.title,
                                  note: state.note,
                                  gpsPosition: state.gpsPosition,
                                  photoUrl: state.photoUrl,
                                );
                                onDeleteCallback(
                                  context,
                                  deletedLocation,
                                  widget.currentUser,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                    if (state.state != LocationFormStateEnum.none) ...[
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

  Center buildLocationLogo(LocationFormState state) {
    return Center(
      child: ProfileImage(
        imageTag: "LOCATION_IMAGE_TAG_${state.id}",
        editable: true,
        image: MyImage(
          imagePath: state.imagePath,
          photoUrl: state.photoUrl,
          defaultImage: const Image(image: defaultLocationImages),
        ),
        radius: 70,
        onUpdatePictureFilePathCallback: (ctxt, pickedFilePath) {
          ctxt.read<LocationFormBloc>().add(
                LocationFormEvent.picturePathChanged(pickedFilePath),
              );
        },
      ),
    );
  }

  Widget buildMap(LocationFormState state, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Card(
        color: Colors.blue,
        elevation: 10,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: state.gpsPosition.value.fold(
                (failure) =>
                    state.currentPosition.value.toOption().toNullable()!,
                (position) => position,
              ),
              zoom: 16),
          onMapCreated: _onMapCreated,
          compassEnabled: false,
          buildingsEnabled: false,
          mapToolbarEnabled: false,
          scrollGesturesEnabled: false,
          //trafficEnabled: false,
          zoomControlsEnabled: false,
          //myLocationEnabled: false,
          // Add little blue dot for device location, requires permission from user
          //mapType: MapType.normal,
          padding: const EdgeInsets.all(8),
          markers: {
            Marker(
              markerId: const MarkerId('current'),
              position: state.gpsPosition.value.fold(
                (failure) =>
                    state.currentPosition.value.toOption().toNullable()!,
                (position) => position,
              ),
              infoWindow: const InfoWindow(title: 'ici'),
            )
          },
        ),
      ),
    );
  }

  void onSaveCallback(BuildContext context, Location updatedlocation,
      String? pickedFilePath, User connectedUser) {
    final LocationFormBloc locationFormBloc = context.read<LocationFormBloc>();
    log(" update location $updatedlocation > $pickedFilePath");

    locationFormBloc.add(
      LocationFormEvent.saveLocation(
        connectedUser: connectedUser,
        location: updatedlocation,
        pickedFilePath: pickedFilePath,
      ),
    );
  }

  Future<void> onDeleteCallback(BuildContext context, Location locationToDelete,
      User connectedUser) async {
    await AlertHelper().confirm(
      context,
      LocaleKeys.profile_deleteLocationConfirm
          .tr(args: [locationToDelete.title.value.getOrElse(() => '')]),
      onConfirmCallback: () {
        final LocationFormBloc locationFormBloc =
            context.read<LocationFormBloc>();
        log(" delete location $locationToDelete");

        locationFormBloc.add(
          LocationFormEvent.deleteLocation(
            connectedUser: connectedUser,
            location: locationToDelete,
          ),
        );
        AutoRouter.of(context).pop();
      },
    );
  }
}
