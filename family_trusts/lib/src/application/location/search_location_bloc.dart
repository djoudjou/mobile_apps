import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/location/bloc.dart';
import 'package:familytrusts/src/domain/location/complex_address.dart';
import 'package:familytrusts/src/domain/location/search_location_failure.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quiver/strings.dart' as quiver;

class SearchLocationBloc
    extends Bloc<SearchLocationEvent, SearchLocationState> {
  late GoogleGeocoding _googleGeocoding;
  static const bounceDuration = Duration(milliseconds: 500);

  SearchLocationBloc() : super(SearchLocationState.initial()) {
    _googleGeocoding = getIt<GoogleGeocoding>();

    on<AddressLookupChanged>(
      _mapAddressLookupChanged,
      transformer: debounce(bounceDuration),
    );
  }

  Future<void> _mapAddressLookupChanged(
    AddressLookupChanged event,
    Emitter<SearchLocationState> emit,
  ) async {
    if (quiver.isNotBlank(event.addressLookupText) &&
        event.addressLookupText.isNotEmpty) {
      emit(
        state.copyWith(
          searchLocationFailureOrSuccessOption: none(),
          isSubmitting: true,
        ),
      );

      try {
        final GeocodingResponse? response =
            await _googleGeocoding.geocoding.get(
          event.addressLookupText,
          <Component>[],
          language: "fr",
          region: "fr",
        );

        Either<SearchLocationFailure, List<ComplexAddress>>?
            searchLocationFailureOrSuccessOption;
        if (response == null || (response.results?.isEmpty ?? true)) {
          searchLocationFailureOrSuccessOption = null;
        } else {
          searchLocationFailureOrSuccessOption = right(
            response.results!
                .map(
                  (geocodingResult) => ComplexAddress(
                    position: LatLng(
                      geocodingResult.geometry!.location!.lat!,
                      geocodingResult.geometry!.location!.lng!,
                    ),
                    address: geocodingResult.formattedAddress,
                  ),
                )
                .toList(),
          );
        }

        emit(
          state.copyWith(
            searchLocationFailureOrSuccessOption:
                optionOf(searchLocationFailureOrSuccessOption),
            isSubmitting: false,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            searchLocationFailureOrSuccessOption:
                some(left(const SearchLocationFailure.serverError())),
            isSubmitting: false,
          ),
        );
      }
    }
  }
}
