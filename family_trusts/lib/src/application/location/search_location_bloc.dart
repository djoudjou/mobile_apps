import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/location/complex_address.dart';
import 'package:familytrusts/src/domain/location/search_location_failure.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quiver/strings.dart' as quiver;
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SearchLocationBloc
    extends Bloc<SearchLocationEvent, SearchLocationState> {
  late GoogleGeocoding _googleGeocoding;

  SearchLocationBloc() : super(SearchLocationState.initial()) {
    _googleGeocoding = getIt<GoogleGeocoding>();
  }

  @override
  Stream<Transition<SearchLocationEvent, SearchLocationState>> transformEvents(
      Stream<SearchLocationEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchLocationState> mapEventToState(
    SearchLocationEvent event,
  ) async* {
    yield* event.map(
      addressLookupChanged: (e) async* {
        if (quiver.isNotBlank(e.addressLookupText) &&
            e.addressLookupText.isNotEmpty) {
          yield state.copyWith(
            searchLocationFailureOrSuccessOption: none(),
            isSubmitting: true,
          );

          try {
            final GeocodingResponse? response =
                await _googleGeocoding.geocoding.get(
              e.addressLookupText,
              <Component>[],
              language: "fr",
              region: "fr",
            );

            Either<SearchLocationFailure, List<ComplexAddress>>?
                searchLocationFailureOrSuccessOption;
            if (response == null || (response.results?.isEmpty ?? true)) {
              searchLocationFailureOrSuccessOption = null;
            } else {
              searchLocationFailureOrSuccessOption = right(response.results!
                  .map(
                    (geocodingResult) => ComplexAddress(
                      position: LatLng(
                        geocodingResult.geometry!.location!.lat!,
                        geocodingResult.geometry!.location!.lng!,
                      ),
                      address: geocodingResult.formattedAddress,
                    ),
                  )
                  .toList());
            }

            yield state.copyWith(
              searchLocationFailureOrSuccessOption:
                  optionOf(searchLocationFailureOrSuccessOption),
              isSubmitting: false,
            );
          } catch (e) {
            yield state.copyWith(
              searchLocationFailureOrSuccessOption:
                  some(left(const SearchLocationFailure.serverError())),
              isSubmitting: false,
            );
          }
        }
      },
    );
  }
}
