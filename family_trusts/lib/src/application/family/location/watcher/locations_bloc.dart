import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import 'bloc.dart';

@injectable
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final IFamilyRepository _familyRepository;
  StreamSubscription? _locationsSubscription;

  LocationsBloc(
    this._familyRepository,
  ) : super(const LocationsState.loading());

  @override
  Stream<LocationsState> mapEventToState(
    LocationsEvent event,
  ) async* {
    yield* event.map(
      loadLocations: (event) {
        return _mapLoadLocationsToState(event);
      },
      locationsUpdated: (event) {
        return _mapLocationsUpdatedToState(event);
      },
    );
  }

  Stream<LocationsState> _mapLoadLocationsToState(LoadLocations event) async* {
    if (quiver.isNotBlank(event.familyId)) {
      yield const LocationsState.loading();
      //await Future.delayed(const Duration(seconds: 10));
      _locationsSubscription?.cancel();
      _locationsSubscription =
          _familyRepository.getLocations(event.familyId!).listen((event) {
        add(LocationsUpdated(locations: event));
      }, onError: (_) {
        _locationsSubscription?.cancel();
      });
    } else {
      yield const LocationsState.locationsNotLoaded();
    }
  }

  Stream<LocationsState> _mapLocationsUpdatedToState(
      LocationsUpdated event) async* {
    yield LocationsState.locationsLoaded(locations: event.locations);
  }

  @override
  Future<void> close() {
    _locationsSubscription?.cancel();
    return super.close();
  }
}
