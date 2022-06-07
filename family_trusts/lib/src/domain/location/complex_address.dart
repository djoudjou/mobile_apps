import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
part 'complex_address.freezed.dart';

@freezed
class ComplexAddress with _$ComplexAddress {
  const ComplexAddress._(); // Added constructor

  const factory ComplexAddress({
    LatLng? position,
    String? address,
    String? photoUrl,
  }) = _ComplexAddress;
}
