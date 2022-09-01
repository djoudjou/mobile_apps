import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locations_event.freezed.dart';

@freezed
class LocationsEvent with _$LocationsEvent {
  const factory LocationsEvent.loadLocations(String? familyId) = LoadLocations;
}
