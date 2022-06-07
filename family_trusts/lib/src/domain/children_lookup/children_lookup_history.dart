import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'value_objects.dart';

part 'children_lookup_history.freezed.dart';

@freezed
 class ChildrenLookupHistory with _$ChildrenLookupHistory {
  const ChildrenLookupHistory._(); // Added constructor

  const factory ChildrenLookupHistory({
    required String id,
    required User subject,
    required MissionEventType eventType,
    required TimestampVo creationDate,
    required String message,
  }) = _ChildrenLookupHistory;
}
