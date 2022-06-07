import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location_success.dart';
import 'package:familytrusts/src/domain/family/locations/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'location_form_state.freezed.dart';

@freezed
class LocationFormState with _$LocationFormState {
  const factory LocationFormState({
    required bool showErrorMessages,
    required LocationFormStateEnum state,
    required bool isInitializing,
    required Name title,
    required Address address,
    required GpsPosition gpsPosition,
    required NoteBody note,
    required GpsPosition currentPosition,
    String? id,
    String? photoUrl,
    String? imagePath,
    String? familyId,
    required Option<Either<LocationFailure, LocationSuccess>> failureOrSuccessOption,
  }) = _LocationFormState;

  factory LocationFormState.initial() => LocationFormState(
        showErrorMessages: false,
        state: LocationFormStateEnum.none,
        isInitializing: true,
        failureOrSuccessOption: none(),
        address: Address(''),
        currentPosition:
            GpsPosition.fromPosition(latitude: 48.8534, longitude: 2.3488),
        gpsPosition:
            GpsPosition.fromPosition(latitude: 48.8534, longitude: 2.3488),
        note: NoteBody(''),
        title: Name(''),
        photoUrl: '',
        imagePath: '',
        familyId: '',
      );
}
