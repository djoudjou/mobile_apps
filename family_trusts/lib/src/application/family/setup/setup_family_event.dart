import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_family_event.freezed.dart';

@freezed
abstract class SetupFamilyEvent with _$SetupFamilyEvent {
  const factory SetupFamilyEvent.endedSpouseRelationTriggered({
    required User from,
    required User to,
  }) = EndedSpouseRelationTriggered;

  const factory SetupFamilyEvent.askToJoinFamilyTriggered({
    required User from,
    required User to,
  }) = AskToJoinFamilyTriggered;

  const factory SetupFamilyEvent.joinFamilyCancelTriggered({
    required Invitation invitation,
  }) = JoinFamilyCancelTriggered;

  const factory SetupFamilyEvent.acceptInvitationTriggered({
    required Invitation invitation,
  }) = AcceptInvitationTriggered;

  const factory SetupFamilyEvent.declineInvitationTriggered({
    required Invitation invitation,
  }) = DeclineInvitationTriggered;
}
