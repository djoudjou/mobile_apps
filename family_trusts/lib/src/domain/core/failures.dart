import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.exceedingLength({
    required T failedValue,
    required int max,
  }) = ExceedingLength<T>;

  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;

  const factory ValueFailure.multiline({
    required T failedValue,
  }) = Multiline<T>;

  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.shortPassword({
    required T failedValue,
  }) = ShortPassword<T>;

  const factory ValueFailure.invalidEnumValue({
    required String failedValue,
  }) = InvalidEnumValue<T>;

  const factory ValueFailure.invalidBirthdayValue({
    required T failedValue,
  }) = InvalidBirthdayValue<T>;

  const factory ValueFailure.invalidRendezVousValue({
    required T failedValue,
  }) = InvalidRendezVousValue<T>;
}
