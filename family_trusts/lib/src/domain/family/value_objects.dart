import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_validators.dart';
import 'package:familytrusts/src/helper/date_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum FamilyFormStateEnum {
  none,
  adding,
  updating,
  deleting,
}

class Birthday extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  factory Birthday.fromValue(String? text) {
    assert(text != null);
    final DateTime? val = birthdayConverterToDate(text).toNullable();

    return (val == null || val.isAfter(DateTime.now()))
        ? Birthday._(left(ValueFailure.invalidBirthdayValue(failedValue: DateTime.now())))
        : Birthday._(right(val));
  }

  factory Birthday.defaultValue() => Birthday._(right(DateTime.now()));

  const Birthday._(this.value);

  String get toText => birthdayConverterToString(getOrCrash());
}

class GpsPosition extends ValueObject<LatLng> {
  @override
  final Either<ValueFailure<LatLng>, LatLng> value;

  factory GpsPosition.fromPosition({
    required double latitude,
    required double longitude,
  }) {
    return GpsPosition._(
      right(
        LatLng(
          latitude,
          longitude,
        ),
      ),
    );
  }

  const GpsPosition._(this.value);
}

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 100;

  factory NoteBody(String input) {
    //assert(input != null);
    return NoteBody._(
      validateMaxStringLength(input, maxLength),
    );
  }

  const NoteBody._(this.value);
}

class Address extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory Address(String input) {
    //assert(input != null);
    return Address._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const Address._(this.value);
}
