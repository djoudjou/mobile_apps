import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/demands/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/demands/demands.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class DemandsBloc extends Bloc<DemandsEvent, DemandsState> {
  final IChildrenLookupRepository _childrenLookupRepository;

  DemandsBloc(
    this._childrenLookupRepository,
  ) : super(const DemandsLoading()) {
    on<LoadDemands>(_mapLoadDemandsToState, transformer: restartable());
  }

  Future<void> _mapLoadDemandsToState(
    LoadDemands event,
    Emitter<DemandsState> emit,
  ) async {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const DemandsState.demandsLoading());
      try {
        final Either<ChildrenLookupFailure, List<ChildrenLookup>>
            eitherFailureOrPassedChildrenLookups =
            await _childrenLookupRepository.getPassedChildrenLookupsByFamilyId(
          familyId: event.familyId!,
        );

        final Either<ChildrenLookupFailure, List<ChildrenLookup>>
            eitherFailureOrInProgressChildrenLookups =
            await _childrenLookupRepository
                .getInProgressChildrenLookupsByFamilyId(
          familyId: event.familyId!,
        );

        emit(
          eitherFailureOrPassedChildrenLookups.fold(
            (failure) => const DemandsState.demandsNotLoaded(),
            (passedChildrenLookups) =>
                eitherFailureOrInProgressChildrenLookups.fold(
              (failure) => const DemandsState.demandsNotLoaded(),
              (inProgressChildrenLookups) => DemandsState.demandsLoaded(
                right(
                  Demands(
                    inProgressChildrenLookups: inProgressChildrenLookups,
                    passedChildrenLookups: passedChildrenLookups,
                  ),
                ),
              ),
            ),
          ),
        );
      } catch (_) {
        emit(const DemandsState.demandsNotLoaded());
      }
    }
  }
}
