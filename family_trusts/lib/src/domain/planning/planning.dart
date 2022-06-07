import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'planning_entry.dart';
part 'planning.freezed.dart';

@freezed
class Planning with _$Planning {
  const factory Planning({
    required List<PlanningEntry> entries,
  }) = _Planning;
}
