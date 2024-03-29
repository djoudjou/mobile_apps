import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/errors.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/helper/date_helper.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    // id = identity - same as writing (right) => right
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold(
      (l) => left(l),
      (r) => right(unit),
    );
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId() {
    return UniqueId._(
      right(const Uuid().v1()),
    );
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    //assert(uniqueId != null);
    return UniqueId._(
      right(uniqueId),
    );
  }

  const UniqueId._(this.value);
}

class TimestampVo extends ValueObject<int> {
  @override
  final Either<ValueFailure<int>, int> value;

  factory TimestampVo.now() {
    return TimestampVo._(
      right(DateTime.now().millisecondsSinceEpoch),
    );
  }

  factory TimestampVo.fromTimestamp(int timestamp) {
    assert(timestamp > 0);
    return TimestampVo._(
      right(timestamp),
    );
  }

  const TimestampVo._(this.value);

  String get toPrintableDate => getPrintableDateFromTimestamp(getOrCrash());
}
