import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_failure.freezed.dart';

@freezed
class FamilyFailure with _$FamilyFailure {
  const factory FamilyFailure.unexpected() = _Unexpected;
  const factory FamilyFailure.insufficientPermission() = _InsufficientPermission;
  const factory FamilyFailure.unknownFamily(String familyId) = _UnknownFamily;
  const factory FamilyFailure.unableToUpdate() = _UnableToUpdate;
  const factory FamilyFailure.unableToDelete() = _UnableToDelete;
  const factory FamilyFailure.unableToCreate() = _UnableToCreate;
}
