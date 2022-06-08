import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_state.freezed.dart';

@freezed
class ChildrenState with _$ChildrenState {
  const factory ChildrenState.childrenLoading() = ChildrenLoading;

  const factory ChildrenState.childrenLoaded({
    required Either<ChildrenFailure, List<Either<ChildrenFailure, Child>>>
        eitherChildren,
  }) = ChildrenLoaded;

  const factory ChildrenState.childrenNotLoaded() = ChildrenNotLoaded;
}
