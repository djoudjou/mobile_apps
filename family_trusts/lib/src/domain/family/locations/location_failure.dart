import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_failure.freezed.dart';

@freezed
abstract class LocationFailure with _$LocationFailure {
  const factory LocationFailure.unexpected() = _Unexpected;

  const factory LocationFailure.insufficientPermission() =
      _InsufficientPermission;

  const factory LocationFailure.unableToUpdate() = _UnableToUpdate;

  const factory LocationFailure.unableToCreate() = _UnableToCreate;

  const factory LocationFailure.unableToDelete() = _UnableToDelete;
}
