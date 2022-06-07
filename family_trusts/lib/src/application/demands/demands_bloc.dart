import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/demands/demands.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import 'bloc.dart';

@injectable
class DemandsBloc extends Bloc<DemandsEvent, DemandsState> {
  final IChildrenLookupRepository _childrenLookupRepository;
  StreamSubscription? _childrenLookupsSubscription;

  DemandsBloc(
    this._childrenLookupRepository,
  ) : super(const DemandsLoading());

  @override
  Stream<DemandsState> mapEventToState(
    DemandsEvent event,
  ) async* {
    yield* event.map(
      loadDemands: (event) {
        return _mapLoadDemandsToState(event);
      },
      demandsUpdated: (event) {
        return _mapDemandsUpdatedToState(event);
      },
    );
  }

  @override
  Future<void> close() {
    _childrenLookupsSubscription?.cancel();
    return super.close();
  }

  Stream<DemandsState> _mapLoadDemandsToState(LoadDemands event) async* {
    if (quiver.isNotBlank(event.familyId)) {
      yield const DemandsState.demandsLoading();
      try {
        _childrenLookupsSubscription?.cancel();
        _childrenLookupsSubscription = _childrenLookupRepository
            .getChildrenLookupsByFamilyId(familyId: event.familyId!)
            .listen((data) {
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
        }, onError: (_) {
          _childrenLookupsSubscription?.cancel();
        });
      } catch (_) {
        yield const DemandsState.demandsNotLoaded();
      }
    }
  }

  Stream<DemandsState> _mapDemandsUpdatedToState(DemandsUpdated event) async* {
    yield DemandsState.demandsLoaded(event.demands);
  }
}
