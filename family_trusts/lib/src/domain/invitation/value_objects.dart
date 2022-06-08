import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';

enum InvitationTypeEnum {
  spouse,
  trust,
}

class InvitationType extends ValueObject<InvitationTypeEnum> {
  @override
  final Either<ValueFailure<InvitationTypeEnum>, InvitationTypeEnum> value;

  factory InvitationType(InvitationTypeEnum input) {
    //assert(input != null);
    return InvitationType._(right(input));
  }

  factory InvitationType.spouse() {
    return InvitationType(InvitationTypeEnum.spouse);
  }

  factory InvitationType.trust() {
    return InvitationType(InvitationTypeEnum.trust);
  }

  factory InvitationType.fromValue(String text) {
    //assert(text != null);
    final InvitationTypeEnum? val =
        EnumToString.fromString(InvitationTypeEnum.values, text);

    return (val == null)
        ? InvitationType._(
            left(ValueFailure.invalidEnumValue(failedValue: text)),
          )
        : InvitationType._(right(val));
  }

  const InvitationType._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
