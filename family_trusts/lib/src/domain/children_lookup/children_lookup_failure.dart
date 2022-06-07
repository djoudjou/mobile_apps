import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'children_lookup_failure.freezed.dart';

@freezed
class ChildrenLookupFailure with _$ChildrenLookupFailure {
  const factory ChildrenLookupFailure.insufficientPermission() = InsufficientPermission;
  const factory ChildrenLookupFailure.serverError() = ServerError;
  const factory ChildrenLookupFailure.noFamily() = NoFamily;
  const factory ChildrenLookupFailure.userNotConnected() = UserNotConnected;
  const factory ChildrenLookupFailure.unableToUpdate() = UnableToUpdate;

  const factory ChildrenLookupFailure.invalidPersonInCharge(String? userId) = InvalidPersonInCharge;
  const factory ChildrenLookupFailure.invalidIssuer(String? userId) = InvalidIssuer;
  const factory ChildrenLookupFailure.invalidChild(String? childId) = InvalidChild;
  const factory ChildrenLookupFailure.invalidLocation(String? locationId) = InvalidLocation;

  const factory ChildrenLookupFailure.unknowned(String? childrenLookupId) = Unknowned;

}
