import 'package:freezed_annotation/freezed_annotation.dart';

part 'planning_failure.freezed.dart';

@freezed
abstract class PlanningFailure with _$PlanningFailure {
  const factory PlanningFailure.serverError() = _ServerError;
  const factory PlanningFailure.insufficientPermission() = _InsufficientPermission;
}
