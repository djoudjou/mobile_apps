import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_failure.freezed.dart';

@freezed
class ChildrenFailure with _$ChildrenFailure {
  const factory ChildrenFailure.unexpected() = _Unexpected;
  const factory ChildrenFailure.insufficientPermission() = _InsufficientPermission;
  const factory ChildrenFailure.unableToUpdate() = _UnableToUpdate;
}
