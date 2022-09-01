import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_details_event.freezed.dart';

@freezed
class ChildrenLookupDetailsEvent with _$ChildrenLookupDetailsEvent {
  const factory ChildrenLookupDetailsEvent.init({
    required User connectedUser,
    required ChildrenLookup childrenLookup,
  }) = ChildrenLookupDetailsInit;

  const factory ChildrenLookupDetailsEvent.cancel({
    required User connectedUser,
    required ChildrenLookup childrenLookup,
  }) = ChildrenLookupDetailsCancel;
}
