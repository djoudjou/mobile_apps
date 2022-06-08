import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_form_state.freezed.dart';

@freezed
class ChildrenFormState with _$ChildrenFormState {
  const factory ChildrenFormState.init() = _Init;

  const factory ChildrenFormState.addChildInProgress() = _AddChildInProgress;

  const factory ChildrenFormState.addChildSuccess() = _AddChildSuccess;

  const factory ChildrenFormState.addChildFailure() = _AddChildFailure;

  const factory ChildrenFormState.updateChildInProgress() =
      _UpdateChildInProgress;

  const factory ChildrenFormState.updateChildSuccess() = _UpdateChildSuccess;

  const factory ChildrenFormState.updateChildFailure() = _UpdateChildFailure;

  const factory ChildrenFormState.deleteChildInProgress() =
      _DeleteChildInProgress;

  const factory ChildrenFormState.deleteChildSuccess() = _DeleteChildSuccess;

  const factory ChildrenFormState.deleteChildFailure() = _DeleteChildFailure;
}
