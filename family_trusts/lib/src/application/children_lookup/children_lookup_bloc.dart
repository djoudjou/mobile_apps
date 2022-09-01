import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/children_lookup/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class ChildrenLookupBloc
    extends Bloc<ChildrenLookupEvent, ChildrenLookupState> {
  static const bounceDuration = Duration(milliseconds: 500);
  final IFamilyRepository _familyRepository;
  final IChildrenLookupRepository _childrenLookupRepository;

  ChildrenLookupBloc(
    this._familyRepository,
    this._childrenLookupRepository,
  ) : super(ChildrenLookupState.initial()) {
    on<ChildrenLookupInit>(_mapChildrenLookupInit, transformer: sequential());
    on<NoteChanged>(_mapNoteChanged, transformer: debounce(bounceDuration));
    on<ChildSelected>(_mapChildSelected, transformer: restartable());
    on<LocationSelected>(_mapLocationSelected, transformer: restartable());
    on<RendezVousChanged>(_mapRendezVousChanged, transformer: restartable());
    on<Submitted>(_mapSubmitted, transformer: sequential());
    on<Next>(_mapNext, transformer: sequential());
    on<Cancel>(_mapCancel, transformer: sequential());
    on<Goto>(_mapGoto, transformer: sequential());
  }

  FutureOr<void> _mapChildrenLookupInit(
    ChildrenLookupInit event,
    Emitter<ChildrenLookupState> emit,
  ) async {
    if (quiver.isBlank(event.familyId)) {
      emit(
        state.copyWith(
          failureOrSuccessOption:
              some(left(const ChildrenLookupFailure.noFamily())),
        ),
      );
    } else {
      final Either<ChildrenFailure, List<Child>> resultChildren =
          await _familyRepository.getChildren(event.familyId!);

      emit(
        state.copyWith(
          childrenStep: state.childrenStep
              .copyWith(optionEitherChildren: some(resultChildren)),
          failureOrSuccessOption: none(),
        ),
      );

      final Either<LocationFailure, List<Location>> resultLocations =
          await _familyRepository.getLocations(event.familyId!);

      emit(
        state.copyWith(
          locationsStep: state.locationsStep
              .copyWith(optionEitherLocations: some(resultLocations)),
          failureOrSuccessOption: none(),
        ),
      );

      emit(
        state.copyWith(
          isInitializing: false,
          showErrorMessages: true,
          familyId: event.familyId,
        ),
      );
    }
  }

  FutureOr<void> _mapNoteChanged(
    NoteChanged event,
    Emitter<ChildrenLookupState> emit,
  ) {
    emit(
      state.copyWith(
        notesStep: state.notesStep.copyWith(noteBody: NoteBody(event.note)),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapChildSelected(
    ChildSelected event,
    Emitter<ChildrenLookupState> emit,
  ) {
    emit(
      state.copyWith(
        childrenStep: state.childrenStep.copyWith(selectedChild: event.child),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapLocationSelected(
    LocationSelected event,
    Emitter<ChildrenLookupState> emit,
  ) {
    emit(
      state.copyWith(
        locationsStep:
            state.locationsStep.copyWith(selectedLocation: event.location),
        failureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapRendezVousChanged(
    RendezVousChanged event,
    Emitter<ChildrenLookupState> emit,
  ) {
    emit(
      state.copyWith(
        rendezVousStep: state.rendezVousStep
            .copyWith(rendezVous: RendezVous.fromDate(event.dateTime)),
        failureOrSuccessOption: none(),
      ),
    );
  }

  Future<FutureOr<void>> _mapSubmitted(
    Submitted event,
    Emitter<ChildrenLookupState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );

    final childrenLookup = ChildrenLookup(
      rendezVous: state.rendezVousStep.rendezVous,
      noteBody: state.notesStep.noteBody,
      child: state.childrenStep.selectedChild,
      creationDate: TimestampVo.now(),
      issuer: event.connectedUser,
      location: state.locationsStep.selectedLocation,
      state: MissionState.waiting(),
    );

    final Either<ChildrenLookupFailure, Unit> resultCreate =
        await _childrenLookupRepository.createChildrenLookup(
      childrenLookup: childrenLookup,
    );

    emit(
      resultCreate.fold(
        (failure) => state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: some(left(failure)),
        ),
        (success) => state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: some(right(unit)),
        ),
      ),
    );
  }

  FutureOr<void> _mapNext(Next event, Emitter<ChildrenLookupState> emit) {
    if (state.currentStep + 1 < 4) {
      add(Goto(state.currentStep + 1));
    } else {
      emit(
        state.copyWith(
          isCompleted: isValid(),
        ),
      );
    }
  }

  FutureOr<void> _mapCancel(Cancel event, Emitter<ChildrenLookupState> emit) {
    if (state.currentStep > 0) {
      add(Goto(state.currentStep - 1));
    }
    emit(
      state.copyWith(
        isCompleted: false,
      ),
    );
  }

  FutureOr<void> _mapGoto(Goto event, Emitter<ChildrenLookupState> emit) {
    emit(
      state.copyWith(
        currentStep: event.step,
        childrenStep: state.childrenStep.copyWith(isActive: event.step == 0),
        locationsStep: state.locationsStep.copyWith(isActive: event.step == 1),
        rendezVousStep:
            state.rendezVousStep.copyWith(isActive: event.step == 2),
        notesStep: state.notesStep.copyWith(isActive: event.step == 3),
        //isCompleted: isValid(),
      ),
    );
  }

  String childrenLookupMsg() {
    return LocaleKeys.ask_childlookup_notification_template.tr(
      args: [
        state.childrenStep.selectedChild!.displayName,
        state.locationsStep.selectedLocation!.title.getOrCrash(),
        state.rendezVousStep.rendezVous.toText,
      ],
    );
  }

  bool isValid() {
    return state.childrenStep.selectedChild != null &&
        state.locationsStep.selectedLocation != null &&
        state.rendezVousStep.rendezVous.isValid() &&
        state.notesStep.noteBody.isValid();
  }
}
