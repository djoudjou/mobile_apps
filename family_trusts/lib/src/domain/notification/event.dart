import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const Event._(); // Added constructor
  const factory Event({
    String? id,
    required User from,
    required User to,
    required TimestampVo date,
    required EventType type,
    required String subject,
    required bool fromConnectedUser,
    required bool seen,
  }) = _Event;
}
