import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_details.freezed.dart';

@freezed
class ChildrenLookupDetails with _$ChildrenLookupDetails {
  const ChildrenLookupDetails._(); // Added constructor

  const factory ChildrenLookupDetails({
    required ChildrenLookup childrenLookup,
    required List<ChildrenLookupHistory> histories,
  }) = _ChildrenLookupDetails;
}
