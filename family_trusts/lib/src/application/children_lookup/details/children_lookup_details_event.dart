import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup_details_event.freezed.dart';

@freezed
class ChildrenLookupDetailsEvent with _$ChildrenLookupDetailsEvent {
  const factory ChildrenLookupDetailsEvent.init({
    required ChildrenLookup childrenLookup,
  }) = ChildrenLookupDetailsInit;

  const factory ChildrenLookupDetailsEvent.childrenLookupUpdated({
    required Either<ChildrenLookupFailure, ChildrenLookup> eitherChildrenLookup,
  }) = ChildrenLookupUpdated;

  const factory ChildrenLookupDetailsEvent.childrenLookupHistoriesUpdated({
    required List<Either<ChildrenLookupFailure, ChildrenLookupHistory>>
        eitherChildrenHistory,
  }) = ChildrenLookupHistoryUpdated;

  const factory ChildrenLookupDetailsEvent.ended() = ChildrenLookupDetailsEnded;

  const factory ChildrenLookupDetailsEvent.accept() =
      ChildrenLookupDetailsAccept;

  const factory ChildrenLookupDetailsEvent.decline() =
      ChildrenLookupDetailsDecline;

  const factory ChildrenLookupDetailsEvent.cancel() =
      ChildrenLookupDetailsCancel;
}
