import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'planning_entry.freezed.dart';

@freezed
class PlanningEntry with _$PlanningEntry {
  const factory PlanningEntry({
    required DateTime day,
    required List<ChildrenLookup> childrenLookups,
  }) = _PlanningEntry;
}
