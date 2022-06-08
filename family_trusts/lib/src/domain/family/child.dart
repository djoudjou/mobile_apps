import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
