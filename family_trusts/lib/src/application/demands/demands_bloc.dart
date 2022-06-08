import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/demands/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/demands/demands.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class DemandsBloc extends Bloc<DemandsEvent, DemandsState> {
  final IChildrenLookupRepository _childrenLookupRepository;
  StreamSubscription? _childrenLookupsSubscription;

  DemandsBloc(
    this._childrenLookupRepository,
  ) : super(const DemandsLoading()) {
    on<DemandsEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  void mapEventToState(
    DemandsEvent event,
    Emitter<DemandsState> emit,
  ) {
    event.map(
      loadDemands: (event) {
        _mapLoadDemandsToState(event, emit);
      },
      demandsUpdated: (event) {
        _mapDemandsUpdatedToState(event, emit);
      },
    );
  }

  @override
  Future<void> close() {
    _childrenLookupsSubscription?.cancel();
    return super.close();
  }

  void _mapLoadDemandsToState(
    LoadDemands event,
    Emitter<DemandsState> emit,
  ) {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const DemandsState.demandsLoading());
      try {
        _childrenLookupsSubscription?.cancel();
        _childrenLookupsSubscription = _childrenLookupRepository
            .getChildrenLookupsByFamilyId(familyId: event.familyId!)
            .listen(
          (data) {
            final now = DateTime.now();
            final List<ChildrenLookup> passedChildrenLookups = data
                .map((e) => e.toOption())
                .where((e) => e.isSome())
                .map((e) => e.toNullable()!)
                .where((e) => e.rendezVous.getOrCrash().isBefore(now))
                .toList();
            final List<ChildrenLookup> inProgressChildrenLookups = data
                .map((e) => e.toOption())
                .where((e) => e.isSome())
                .map((e) => e.toNullable()!)
                .where((e) => e.rendezVous.getOrCrash().isAfter(now))
                .toList();
            add(
              DemandsEvent.demandsUpdated(
                right(
                  Demands(
                    inProgressChildrenLookups: inProgressChildrenLookups,
                    passedChildrenLookups: passedChildrenLookups,
                  ),
                ),
              ),
            );
          },
          onError: (_) {
            _childrenLookupsSubscription?.cancel();
          },
        );
      } catch (_) {
        emit(const DemandsState.demandsNotLoaded());
      }
    }
  }

  void _mapDemandsUpdatedToState(
    DemandsUpdated event,
    Emitter<DemandsState> emit,
  ) {
    emit(DemandsState.demandsLoaded(event.demands));
  }
}
