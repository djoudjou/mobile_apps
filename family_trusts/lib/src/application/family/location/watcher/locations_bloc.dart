import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/location/watcher/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final IFamilyRepository _familyRepository;

  LocationsBloc(
    this._familyRepository,
  ) : super(const LocationsState.loading()) {
    on<LoadLocations>(
      _mapLoadLocationsToState,
      transformer: restartable(),
    );
  }

  Future<void> _mapLoadLocationsToState(
    LoadLocations event,
    Emitter<LocationsState> emit,
  ) async {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const LocationsState.loading());

      final Either<LocationFailure, List<Location>> result =
          await _familyRepository.getLocations(event.familyId!);

      emit(
        result.fold(
          (failure) => LocationsState.locationsLoaded(locations: left(failure)),
          (locations) =>
              LocationsState.locationsLoaded(locations: right(locations)),
        ),
      );
    } else {
      emit(const LocationsState.locationsNotLoaded());
    }
  }
}
