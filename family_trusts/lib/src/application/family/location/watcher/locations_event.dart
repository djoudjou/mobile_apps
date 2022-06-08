import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locations_event.freezed.dart';

@freezed
class LocationsEvent with _$LocationsEvent {
  const factory LocationsEvent.loadLocations(String? familyId) = LoadLocations;

  const factory LocationsEvent.locationsUpdated({
    required Either<LocationFailure, List<Either<LocationFailure, Location>>>
        locations,
  }) = LocationsUpdated;
}
