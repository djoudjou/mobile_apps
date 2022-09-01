import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';

enum JoinProposalStateEnum {
  waiting,
  accepted,
  declined,
  rejected,
  canceled,
}

class JoinProposalStatus extends ValueObject<JoinProposalStateEnum> {
  @override
  final Either<ValueFailure<JoinProposalStateEnum>, JoinProposalStateEnum>
      value;

  factory JoinProposalStatus(JoinProposalStateEnum input) {
    return JoinProposalStatus._(right(input));
  }

  factory JoinProposalStatus.waiting() {
    return JoinProposalStatus(JoinProposalStateEnum.waiting);
  }

  factory JoinProposalStatus.accepted() {
    return JoinProposalStatus(JoinProposalStateEnum.accepted);
  }

  factory JoinProposalStatus.rejected() {
    return JoinProposalStatus(JoinProposalStateEnum.rejected);
  }

  factory JoinProposalStatus.declined() {
    return JoinProposalStatus(JoinProposalStateEnum.declined);
  }

  factory JoinProposalStatus.canceled() {
    return JoinProposalStatus(JoinProposalStateEnum.canceled);
  }

  factory JoinProposalStatus.fromValue(String text) {
    //assert(text != null);
    final JoinProposalStateEnum? val =
        EnumToString.fromString(JoinProposalStateEnum.values, text);

    return (val == null)
        ? JoinProposalStatus._(
            left(ValueFailure.invalidEnumValue(failedValue: text)),
          )
        : JoinProposalStatus._(right(val));
  }

  const JoinProposalStatus._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
