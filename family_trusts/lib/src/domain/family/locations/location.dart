import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../value_objects.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const Location._(); // Added constructor
  const factory Location({
    String? id,
    required Name title,
    required Address address,
    required GpsPosition gpsPosition,
    required NoteBody note,
    String? photoUrl,
  }) = _Location;
}
