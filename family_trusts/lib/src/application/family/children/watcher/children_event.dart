import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_event.freezed.dart';

@freezed
class ChildrenEvent with _$ChildrenEvent {
  const factory ChildrenEvent.loadChildren(String? familyId) = LoadChildren;
}
