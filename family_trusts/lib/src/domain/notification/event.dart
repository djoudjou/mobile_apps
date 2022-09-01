import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const Event._(); // Added constructor
  const factory Event({
    String? id,
    required String dateText,
    required String message,
    required bool seen,
  }) = _Event;
}
