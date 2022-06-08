import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_location_event.freezed.dart';

@freezed
class SearchLocationEvent with _$SearchLocationEvent {
  const factory SearchLocationEvent.addressLookupChanged(
    String addressLookupText,
  ) = AddressLookupChanged;
}
