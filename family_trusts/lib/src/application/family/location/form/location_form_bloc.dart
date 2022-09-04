import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/location/form/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location_success.dart';
import 'package:familytrusts/src/domain/family/locations/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class LocationFormBloc extends Bloc<LocationFormEvent, LocationFormState> {
  final IFamilyRepository _familyRepository;
  final AnalyticsSvc _analyticsSvc;

  LocationFormBloc(
    this._familyRepository,
    this._analyticsSvc,
  ) : super(LocationFormState.initial()) {
    on<LocationInit>(
      _mapLocationInit,
      transformer: restartable(),
    );

    on<NoteChanged>(
      _mapNoteChanged,
      transformer: restartable(),
    );

    on<TitleChanged>(
      _mapTitleChanged,
      transformer: restartable(),
    );

    on<AddresChanged>(
      _mapAddressChanged,
      transformer: restartable(),
    );

    on<LatLngChanged>(
      _mapLatLngChanged,
      transformer: restartable(),
    );

    on<PicturePathChanged>(
      _mapPicturePathChanged,
      transformer: restartable(),
    );

    on<PictureUrlChanged>(
      _mapPictureUrlChanged,
      transformer: restartable(),
    );

    on<SaveLocation>(
      _mapSaveLocationToState,
      transformer: restartable(),
    );

    on<DeleteLocation>(
      _mapDeleteLocationToState,
      transformer: restartable(),
    );
  }

  FutureOr<void> _mapSaveLocationToState(
    SaveLocation event,
    Emitter<LocationFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          state: quiver.isNotBlank(event.location.id)
              ? LocationFormStateEnum.updating
              : LocationFormStateEnum.adding,
          failureOrSuccessOption: none(),
        ),
      );
      final User user = event.connectedUser;

      final Either<LocationFailure, Unit> result =
          await _familyRepository.addUpdateLocation(
        familyId: user.family!.id!,
        location: event.location,
        pickedFilePath: event.pickedFilePath,
      );

      emit(
        result.fold(
          (failure) {
            _analyticsSvc.debug("error during location save/update $failure");
            return state.copyWith(
              state: LocationFormStateEnum.none,
              failureOrSuccessOption: some(
                left(
                  quiver.isNotBlank(event.location.id)
                      ? const LocationFailure.unableToUpdate()
                      : const LocationFailure.unableToCreate(),
                ),
              ),
            );
          },
          (success) {
            return state.copyWith(
              state: LocationFormStateEnum.none,
              failureOrSuccessOption: some(
                right(
                  quiver.isNotBlank(event.location.id)
                      ? const LocationSuccess.updateSuccess()
                      : const LocationSuccess.createSuccess(),
                ),
              ),
            );
          },
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          state: LocationFormStateEnum.none,
          failureOrSuccessOption: some(
            left(
              quiver.isNotBlank(event.location.id)
                  ? const LocationFailure.unableToUpdate()
                  : const LocationFailure.unableToCreate(),
            ),
          ),
        ),
      );
    }
  }

  FutureOr<void> _mapDeleteLocationToState(
    DeleteLocation event,
    Emitter<LocationFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          state: LocationFormStateEnum.deleting,
          failureOrSuccessOption: none(),
        ),
      );
      final User user = event.connectedUser;
      final Either<LocationFailure, Unit> result =
          await _familyRepository.deleteLocation(
        familyId: user.family!.id!,
        location: event.location,
      );
      emit(
        result.fold(
          (failure) {
            _analyticsSvc.debug("error during location suppression $failure");
            return state.copyWith(
              state: LocationFormStateEnum.none,
              failureOrSuccessOption: some(left(failure)),
            );
          },
          (success) {
            return state.copyWith(
              state: LocationFormStateEnum.none,
              failureOrSuccessOption:
                  some(right(const LocationSuccess.deleteSucces())),
            );
          },
        ),
      );
    } catch (e) {
      _analyticsSvc.debug("error during location suppression $e");
      emit(
        state.copyWith(
          state: LocationFormStateEnum.none,
          failureOrSuccessOption:
              some(left(const LocationFailure.unableToDelete())),
        ),
      );
    }
  }

  Future<FutureOr<void>> _mapLocationInit(
    LocationInit event,
    Emitter<LocationFormState> emit,
  ) async {
    final location = event.location;

    GpsPosition currentPosition;

    try {
      final Position position = await _determinePosition();
      currentPosition = GpsPosition.fromPosition(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      currentPosition =
          GpsPosition.fromPosition(latitude: 48.8534, longitude: 2.3488);
    }

    final LocationFormState newState = state.copyWith(
      id: event.location.id,
      familyId: event.familyId,
      photoUrl: location.photoUrl,
      address: location.address,
      title: location.title,
      note: location.note,
      isInitializing: false,
      currentPosition: currentPosition,
      gpsPosition: event.location.gpsPosition,
      failureOrSuccessOption: none(),
    );
    emit(newState);
  }

  FutureOr<void> _mapNoteChanged(
    NoteChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        note: NoteBody(event.note),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapPictureUrlChanged(
    PictureUrlChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        photoUrl: event.pickedFileUrl,
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapPicturePathChanged(
    PicturePathChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        imagePath: event.pickedFilePath,
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapLatLngChanged(
    LatLngChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        gpsPosition: GpsPosition.fromPosition(
          latitude: event.position.latitude,
          longitude: event.position.longitude,
        ),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapTitleChanged(
    TitleChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        title: Name(event.title),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapAddressChanged(
    AddresChanged event,
    Emitter<LocationFormState> emit,
  ) {
    emit(
      state.copyWith(
        address: Address(event.address),
        failureOrSuccessOption: none(),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    //Position? position = await Geolocator.getLastKnownPosition();

    return Geolocator.getCurrentPosition();
  }
}
