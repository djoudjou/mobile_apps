import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locations_state.freezed.dart';

@freezed
class LocationsState with _$LocationsState {
  const factory LocationsState.loading() = LocationsLoading;

  const factory LocationsState.locationsLoaded({
    required Either<LocationFailure, List<Location>>
        locations,
  }) = LocationsLoaded;

  const factory LocationsState.locationsNotLoaded() = LocationsNotLoaded;
}
