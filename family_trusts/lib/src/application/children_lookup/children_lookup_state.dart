import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_step.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'children_lookup_state.freezed.dart';

@freezed
class ChildrenLookupState with _$ChildrenLookupState {
  const factory ChildrenLookupState({
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isInitializing,
    required bool isCompleted,
    required int currentStep,
    String? familyId,
    required NotesStep notesStep,
    required ChildrenStep childrenStep,
    required LocationsStep locationsStep,
    required RendezVousStep rendezVousStep,
    required Option<Either<ChildrenLookupFailure, Unit>> failureOrSuccessOption,
  }) = _ChildrenLookupState;

  factory ChildrenLookupState.initial() => ChildrenLookupState(
        showErrorMessages: false,
        isSubmitting: false,
        isInitializing: true,
        isCompleted: false,
        currentStep: 0,
        failureOrSuccessOption: none(),
        childrenStep: ChildrenStep(
          isActive: true,
          optionEitherChildren: none(),
        ),
        locationsStep: LocationsStep(
          isActive: false,
          optionEitherLocations: none(),
        ),
        rendezVousStep: RendezVousStep(
          isActive: false,
          rendezVous: RendezVous.defaultValue(),
        ),
        notesStep: NotesStep(
          isActive: false,
          noteBody: NoteBody(""),
        ),
      );
}
