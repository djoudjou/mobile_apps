import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects.dart';

part 'child.freezed.dart';

@freezed
class Child with _$Child {
  const Child._(); // Added constructor
  const factory Child({
    String? id,
    required Name name,
    required Surname surname,
    required Birthday birthday,
    String? photoUrl,
  }) = _Child;

  String get displayName => "${surname.getOrCrash()} ${name.getOrCrash()}";
}
