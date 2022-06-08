import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_event.freezed.dart';

@freezed
class ChildrenEvent with _$ChildrenEvent {
  const factory ChildrenEvent.loadChildren(String? familyId) = LoadChildren;

  const factory ChildrenEvent.childrenUpdated({
    required Either<ChildrenFailure, List<Either<ChildrenFailure, Child>>>
        eitherChildren,
  }) = ChildrenUpdated;
}
