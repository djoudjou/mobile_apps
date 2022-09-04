import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_validators.dart';

enum TrustedUserFormStateEnum {
  none,
  initializing,
  submiting,
  removing,
}

class PhoneNumber extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory PhoneNumber(String? input) {
    assert(input != null);
    return PhoneNumber._(
      validatePhoneNumber(input!),
    );
  }

  const PhoneNumber._(this.value);
}
