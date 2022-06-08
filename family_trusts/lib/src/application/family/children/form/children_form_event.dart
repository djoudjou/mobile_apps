import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_form_event.freezed.dart';

@freezed
class ChildrenFormEvent with _$ChildrenFormEvent {
  const factory ChildrenFormEvent.addChild({
    String? pickedFilePath,
    required Child child,
    required User user,
  }) = AddChild;

  const factory ChildrenFormEvent.updateChild({
    String? pickedFilePath,
    required Child child,
    required User user,
  }) = UpdateChild;

  const factory ChildrenFormEvent.deleteChild({
    required Child child,
    required User user,
  }) = DeleteChild;
}
