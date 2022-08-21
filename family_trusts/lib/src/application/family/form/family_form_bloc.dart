import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/form/bloc.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/family_success.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart' as quiver;

class FamilyFormBloc extends Bloc<FamilyFormEvent, FamilyFormState> {
  final IFamilyRepository _familyRepository;
  final AnalyticsSvc _analyticsSvc;

  FamilyFormBloc(
    this._familyRepository,
    this._analyticsSvc,
  ) : super(FamilyFormState.initial()) {
    on<FamilyInit>(
      _mapFamilyInit,
      transformer: sequential(),
    );

    on<NameChanged>(
      _mapNameChanged,
      transformer: sequential(),
    );

    on<SaveFamily>(
      _mapSaveFamily,
      transformer: sequential(),
    );

    on<DeleteFamily>(
      _mapDeleteFamily,
      transformer: sequential(),
    );
  }

  FutureOr<void> _mapFamilyInit(
    FamilyInit event,
    Emitter<FamilyFormState> emit,
  ) async {
    final FamilyFormState newState = state.copyWith(
      id: event.family.id,
      isInitializing: false,
      failureOrSuccessOption: none(),
    );
    emit(newState);
  }

  FutureOr<void> _mapNameChanged(
    NameChanged event,
    Emitter<FamilyFormState> emit,
  ) {
    emit(
      state.copyWith(
        name: Name(event.name),
        failureOrSuccessOption: none(),
      ),
    );
  }

  Future<FutureOr<void>> _mapSaveFamily(
    SaveFamily event,
    Emitter<FamilyFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          state: quiver.isNotBlank(event.family.id)
              ? FamilyFormStateEnum.updating
              : FamilyFormStateEnum.adding,
          failureOrSuccessOption: none(),
        ),
      );
      final User user = event.connectedUser;

      final Either<FamilyFailure, String> result =
          await _familyRepository.create(
        userId: user.id!,
        family: event.family,
      );

      emit(
        result.fold(
          (failure) {
            _analyticsSvc.debug("error during family save/update $failure");
            return state.copyWith(
              state: FamilyFormStateEnum.none,
              failureOrSuccessOption: some(
                left(
                  quiver.isNotBlank(event.family.id)
                      ? const FamilyFailure.unableToUpdate()
                      : const FamilyFailure.unableToCreate(),
                ),
              ),
            );
          },
          (success) {
            final String familyName = success;
            return state.copyWith(
              state: FamilyFormStateEnum.none,
              failureOrSuccessOption: some(
                right(
                  quiver.isNotBlank(event.family.id)
                      ? FamilySuccess.updateSuccess(familyName)
                      : FamilySuccess.createSuccess(familyName),
                ),
              ),
            );
          },
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          state: FamilyFormStateEnum.none,
          failureOrSuccessOption: some(
            left(
              quiver.isNotBlank(event.family.id)
                  ? const FamilyFailure.unableToUpdate()
                  : const FamilyFailure.unableToCreate(),
            ),
          ),
        ),
      );
    }
  }

  Future<FutureOr<void>> _mapDeleteFamily(
    DeleteFamily event,
    Emitter<FamilyFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          state: FamilyFormStateEnum.deleting,
          failureOrSuccessOption: none(),
        ),
      );
      final User user = event.connectedUser;
      final Either<FamilyFailure, Unit> result =
          await _familyRepository.deleteFamily(
        familyId: user.family!.id!,
      );
      emit(
        result.fold(
          (failure) {
            _analyticsSvc.debug("error during family suppression $failure");
            return state.copyWith(
              state: FamilyFormStateEnum.none,
              failureOrSuccessOption: some(left(failure)),
            );
          },
          (success) {
            return state.copyWith(
              state: FamilyFormStateEnum.none,
              failureOrSuccessOption:
                  some(right(const FamilySuccess.deleteSucces())),
            );
          },
        ),
      );
    } catch (e) {
      _analyticsSvc.debug("error during family suppression $e");
      emit(
        state.copyWith(
          state: FamilyFormStateEnum.none,
          failureOrSuccessOption:
              some(left(const FamilyFailure.unableToDelete())),
        ),
      );
    }
  }
}
