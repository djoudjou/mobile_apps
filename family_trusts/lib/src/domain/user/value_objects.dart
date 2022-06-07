import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/core/value_validators.dart';

enum UserFormStateEnum {
  none,
  initializing,
  submiting,
  unTrusting,
}


class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String? input) {
    assert(input != null);
    return EmailAddress._(
      validateEmailAddress(input!),
    );
  }

  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String? input) {
    assert(input != null);
    return Password._(
      validatePassword(input!),
    );
  }

  const Password._(this.value);
}

class Surname extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Surname(String? input) {
    assert(input != null);
    return Surname._(
      validateStringNotEmpty(input!),
    );
  }

  const Surname._(this.value);
}

class Name extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Name(String? input) {
    assert(input != null);
    return Name._(
      validateStringNotEmpty(input!),
    );
  }

  const Name._(this.value);
}
