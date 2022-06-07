import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:familytrusts/src/domain/core/failures.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';

enum EventTypeEnum {
  spouseProposal,
  spouseProposalAccepted,
  spouseProposalCanceled,
  spouseProposalDeclined,
  spouseRemoved,
  trustProposal,
  trustProposalAccepted,
  trustProposalCanceled,
  trustProposalDeclined,
  trustAdded,
  trustRemoved,
  childAdded,
  childUpdated,
  childRemoved,
  locationAdded,
  locationUpdated,
  locationRemoved,

  childrenLookupAdded,
  childrenLookupAccepted,
  childrenLookupDecline,
  childrenLookupEnded,
  childrenLookupCanceled,
}

class EventType extends ValueObject<EventTypeEnum> {
  @override
  final Either<ValueFailure<EventTypeEnum>, EventTypeEnum> value;

  factory EventType(EventTypeEnum input) {
    //assert(input != null);
    return EventType._(right(input));
  }

  factory EventType.spouseProposal() {
    return EventType(EventTypeEnum.spouseProposal);
  }

  factory EventType.trustProposal() {
    return EventType(EventTypeEnum.trustProposal);
  }

  factory EventType.spouseProposalAccepted() {
    return EventType(EventTypeEnum.spouseProposalAccepted);
  }

  factory EventType.trustProposalAccepted() {
    return EventType(EventTypeEnum.trustProposalAccepted);
  }

  factory EventType.spouseProposalCanceled() {
    return EventType(EventTypeEnum.spouseProposalCanceled);
  }

  factory EventType.trustProposalCanceled() {
    return EventType(EventTypeEnum.trustProposalCanceled);
  }

  factory EventType.spouseProposalDeclined() {
    return EventType(EventTypeEnum.spouseProposalDeclined);
  }

  factory EventType.trustProposalDeclined() {
    return EventType(EventTypeEnum.trustProposalDeclined);
  }

  factory EventType.trustAdded() {
    return EventType(EventTypeEnum.trustAdded);
  }

  factory EventType.childAdded() {
    return EventType(EventTypeEnum.childAdded);
  }

  factory EventType.childUpdated() {
    return EventType(EventTypeEnum.childUpdated);
  }

  factory EventType.childRemoved() {
    return EventType(EventTypeEnum.childRemoved);
  }

  factory EventType.spouseRemoved() {
    return EventType(EventTypeEnum.spouseRemoved);
  }

  factory EventType.trustRemoved() {
    return EventType(EventTypeEnum.trustRemoved);
  }

  factory EventType.locationAdded() {
    return EventType(EventTypeEnum.locationAdded);
  }

  factory EventType.locationUpdated() {
    return EventType(EventTypeEnum.locationUpdated);
  }

  factory EventType.locationRemoved() {
    return EventType(EventTypeEnum.locationRemoved);
  }

  factory EventType.childrenLookupAdded() {
    return EventType(EventTypeEnum.childrenLookupAdded);
  }

  factory EventType.childrenLookupAccepted() {
    return EventType(EventTypeEnum.childrenLookupAccepted);
  }

  factory EventType.childrenLookupDecline() {
    return EventType(EventTypeEnum.childrenLookupDecline);
  }

  factory EventType.childrenLookupEnded() {
    return EventType(EventTypeEnum.childrenLookupEnded);
  }

  factory EventType.childrenLookupCanceled() {
    return EventType(EventTypeEnum.childrenLookupCanceled);
  }

  factory EventType.fromValue(String text) {
    //assert(text != null);
    final EventTypeEnum? val =
        EnumToString.fromString(EventTypeEnum.values, text);

    return (val == null)
        ? EventType._(left(ValueFailure.invalidEnumValue(failedValue: text)))
        : EventType._(right(val));
  }

  const EventType._(this.value);

  String get toText => EnumToString.convertToString(getOrCrash());
}
