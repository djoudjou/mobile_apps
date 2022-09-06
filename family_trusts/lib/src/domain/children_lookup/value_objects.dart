import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/helper/date_helper.dart';

class RendezVous extends ValueObject<DateTime> {
  @override
  final Either<ValueFailure<DateTime>, DateTime> value;

  factory RendezVous.fromDate(DateTime val) {
    return RendezVous._(right(val));
  }

  factory RendezVous.fromValue(String text) {
    final Option<DateTime> val = rendezVousConverterToDate(text);
    return val.fold(
      () => RendezVous._(
        left(
          ValueFailure.invalidRendezVousValue(failedValue: DateTime.now()),
        ),
      ),
      (a) => RendezVous.fromDate(a),
    );
    //return RendezVous.fromDate(val);
  }

  factory RendezVous.defaultValue() => RendezVous._(right(DateTime.now()));

  const RendezVous._(this.value);

  String get toText => rendezVousConverterToString(getOrCrash());

  String get toHourText => rendezVousConverterToHourString(getOrCrash());
}

///
/// MissionState
///
/// Waiting <-> Taken -> Ended

enum MissionStateEnum {
  WAITING_RESPONSE,
  REJECTED,
  ACCEPTED,
  PICKEDUP,
  CANCELED,
}

class MissionState extends ValueObject<MissionStateEnum> {
  @override
  final Either<ValueFailure<MissionStateEnum>, MissionStateEnum> value;

  factory MissionState(MissionStateEnum input) {
    return MissionState._(right(input));
  }

  factory MissionState.fromValue(String text) {
    //assert(text != null);
    final MissionStateEnum? val =
        EnumToString.fromString(MissionStateEnum.values, text);

    return (val == null)
        ? MissionState._(left(ValueFailure.invalidEnumValue(failedValue: text)))
        : MissionState._(right(val));
  }

  const MissionState._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
