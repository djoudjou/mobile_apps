import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_history.freezed.dart';

@freezed
class ChildrenLookupHistory with _$ChildrenLookupHistory {
  const ChildrenLookupHistory._(); // Added constructor

  const factory ChildrenLookupHistory({
    required String id,
    required String creationDate,
    required String message,
  }) = _ChildrenLookupHistory;
}
