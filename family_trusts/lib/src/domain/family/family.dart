import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family.freezed.dart';

@freezed
class Family with _$Family {
  const Family._(); // Added constructor
  const factory Family({
    String? id,
    required Name name,
  }) = _Family;

  String get displayName => name.getOrCrash();
}
