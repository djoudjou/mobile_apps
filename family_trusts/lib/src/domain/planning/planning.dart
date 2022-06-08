import 'package:familytrusts/src/domain/planning/planning_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'planning.freezed.dart';

@freezed
class Planning with _$Planning {
  const factory Planning({
    required List<PlanningEntry> entries,
  }) = _Planning;
}
