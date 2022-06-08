import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/family/location/watcher/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final IFamilyRepository _familyRepository;
  StreamSubscription? _locationsSubscription;

  LocationsBloc(
    this._familyRepository,
  ) : super(const LocationsState.loading()) {
    on<LocationsEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  void mapEventToState(
    LocationsEvent event,
    Emitter<LocationsState> emit,
  ) {
    event.map(
      loadLocations: (event) {
        _mapLoadLocationsToState(event, emit);
      },
      locationsUpdated: (event) {
        _mapLocationsUpdatedToState(event, emit);
      },
    );
  }

  void _mapLoadLocationsToState(
    LoadLocations event,
    Emitter<LocationsState> emit,
  ) {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const LocationsState.loading());
      //await Future.delayed(const Duration(seconds: 10));
      _locationsSubscription?.cancel();
      _locationsSubscription =
          _familyRepository.getLocations(event.familyId!).listen(
        (event) {
          add(LocationsUpdated(locations: event));
        },
        onError: (_) {
          _locationsSubscription?.cancel();
        },
      );
    } else {
      emit(const LocationsState.locationsNotLoaded());
    }
  }

  void _mapLocationsUpdatedToState(
    LocationsUpdated event,
    Emitter<LocationsState> emit,
  ) {
    emit(LocationsState.locationsLoaded(locations: event.locations));
  }

  @override
  Future<void> close() {
    _locationsSubscription?.cancel();
    return super.close();
  }
}
