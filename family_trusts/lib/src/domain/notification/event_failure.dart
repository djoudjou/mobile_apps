import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_failure.freezed.dart';

@freezed
abstract class EventFailure with _$EventFailure {
  const factory EventFailure.unexpected() = _Unexpected;
  const factory EventFailure.unableToLoadUserFrom(String userId) = _UnableToLoadUserFrom;
  const factory EventFailure.unableToLoadUserTo(String userId) = _UnableToLoadUserTo;
}
