import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';

abstract class IJoinProposalRepository {
  Future<Either<JoinProposalFailure, Unit>> sendProposal(
    User connectedUser,
    Family family,
  );

  Future<Either<JoinProposalFailure, Unit>> cancelProposal(
    User connectedUser,
    String joinProposalId,
  );

  Future<Either<JoinProposalFailure, List<JoinProposal>>> findAllByUser(
      User connectedUser);
}
