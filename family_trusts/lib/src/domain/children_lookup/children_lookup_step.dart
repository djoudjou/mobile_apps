import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'children_lookup_step.freezed.dart';

enum ChildrenLookupStepTypes {
  children,
  locations,
  date,
}

@freezed
class ChildrenStep with _$ChildrenStep {
  const factory ChildrenStep({
    required bool isActive,
    required
        Option<Either<ChildrenFailure, List<Either<ChildrenFailure, Child>>>>
            optionEitherChildren,
    Child? selectedChild,
  }) = _ChildrenStep;
}

@freezed
class LocationsStep with _$LocationsStep {
  const factory LocationsStep({
    required bool isActive,
    required
        Option<Either<LocationFailure, List<Either<LocationFailure, Location>>>>
            optionEitherLocations,
    Location? selectedLocation,
  }) = _LocationsStep;
}

@freezed
class NotesStep with _$NotesStep {
  const factory NotesStep({
    required bool isActive,
    required NoteBody noteBody,
  }) = _NotesStep;
}


@freezed
class RendezVousStep with _$RendezVousStep {
  const factory RendezVousStep({
    required bool isActive,
    required RendezVous rendezVous,
  }) = _RendezVousStep;
}
