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
    final Option<DateTime> val = DateHelper.rendezVousConverterToDate(text);
    return val.fold(
        () => RendezVous._(left(
            ValueFailure.invalidRendezVousValue(failedValue: DateTime.now()))),
        (a) => RendezVous.fromDate(a));
    //return RendezVous.fromDate(val);
  }

  factory RendezVous.defaultValue() => RendezVous._(right(DateTime.now()));

  const RendezVous._(this.value);

  String get toText => DateHelper.rendezVousConverterToString(getOrCrash());
  String get toHourText => DateHelper.rendezVousConverterToHourString(getOrCrash());
}

///
/// MissionState
///
/// Waiting <-> Taken -> Ended

enum MissionStateEnum {
  waiting,
  accepted,
  ended,
  canceled,
}

class MissionState extends ValueObject<MissionStateEnum> {
  @override
  final Either<ValueFailure<MissionStateEnum>, MissionStateEnum> value;

  factory MissionState(MissionStateEnum input) {
    return MissionState._(right(input));
  }

  factory MissionState.waiting() {
    return MissionState(MissionStateEnum.waiting);
  }

  factory MissionState.accepted() {
    return MissionState(MissionStateEnum.accepted);
  }

  factory MissionState.ended() {
    return MissionState(MissionStateEnum.ended);
  }

  factory MissionState.canceled() {
    return MissionState(MissionStateEnum.canceled);
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

enum MissionEventTypeEnum {
  created,
  accepted,
  declined,
  ended,
  canceled,
}

class MissionEventType extends ValueObject<MissionEventTypeEnum> {
  @override
  final Either<ValueFailure<MissionEventTypeEnum>, MissionEventTypeEnum> value;

  factory MissionEventType(MissionEventTypeEnum input) {
    //assert(input != null);
    return MissionEventType._(right(input));
  }

  factory MissionEventType.created() {
    return MissionEventType(MissionEventTypeEnum.created);
  }

  factory MissionEventType.accepted() {
    return MissionEventType(MissionEventTypeEnum.accepted);
  }

  factory MissionEventType.declined() {
    return MissionEventType(MissionEventTypeEnum.declined);
  }

  factory MissionEventType.ended() {
    return MissionEventType(MissionEventTypeEnum.ended);
  }

  factory MissionEventType.canceled() {
    return MissionEventType(MissionEventTypeEnum.canceled);
  }

  factory MissionEventType.fromValue(String text) {
    //assert(text != null);
    final MissionEventTypeEnum? val =
        EnumToString.fromString(MissionEventTypeEnum.values, text);

    return (val == null)
        ? MissionEventType._(
            left(ValueFailure.invalidEnumValue(failedValue: text)))
        : MissionEventType._(right(val));
  }

  const MissionEventType._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
