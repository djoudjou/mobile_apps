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

class JoinProposalState extends ValueObject<JoinProposalStateEnum> {
  @override
  final Either<ValueFailure<JoinProposalStateEnum>, JoinProposalStateEnum>
      value;

  factory JoinProposalState(JoinProposalStateEnum input) {
    return JoinProposalState._(right(input));
  }

  factory JoinProposalState.waiting() {
    return JoinProposalState(JoinProposalStateEnum.waiting);
  }

  factory JoinProposalState.accepted() {
    return JoinProposalState(JoinProposalStateEnum.accepted);
  }

  factory JoinProposalState.rejected() {
    return JoinProposalState(JoinProposalStateEnum.rejected);
  }

  factory JoinProposalState.declined() {
    return JoinProposalState(JoinProposalStateEnum.declined);
  }

  factory JoinProposalState.canceled() {
    return JoinProposalState(JoinProposalStateEnum.canceled);
  }

  factory JoinProposalState.fromValue(String text) {
    //assert(text != null);
    final JoinProposalStateEnum? val =
        EnumToString.fromString(JoinProposalStateEnum.values, text);

    return (val == null)
        ? JoinProposalState._(
            left(ValueFailure.invalidEnumValue(failedValue: text)))
        : JoinProposalState._(right(val));
  }

  const JoinProposalState._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
