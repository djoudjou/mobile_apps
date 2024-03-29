import 'package:familytrusts/src/domain/children_lookup/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'children_lookup.freezed.dart';

@freezed
class ChildrenLookup with _$ChildrenLookup {
  const ChildrenLookup._(); // Added constructor

  const factory ChildrenLookup({
    String? id,
    User? issuer,
    TrustedUser? personInCharge,
    Child? child,
    Location? location,
    MissionState? state,
    required RendezVous rendezVous,
    required NoteBody noteBody,
    required TimestampVo creationDate,
  }) = _ChildrenLookup;
}
