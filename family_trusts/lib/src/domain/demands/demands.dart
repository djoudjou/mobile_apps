import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'demands.freezed.dart';

@freezed
class Demands with _$Demands {
  const factory Demands({
    required List<ChildrenLookup> inProgressChildrenLookups,
    required List<ChildrenLookup> passedChildrenLookups,
  }) = _Demands;
}
