import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';

abstract class ISpouseProposalRepository {
  Future<Either<InvitationFailure, Invitation?>> getSpouseProposal(String userId);

  Future<Either<InvitationFailure, Unit>> createSpouseProposal(
      User user, Invitation invitation);

  Future<Either<InvitationFailure, Unit>> deleteSpouseProposal(User user);
}
