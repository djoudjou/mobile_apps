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

  Future<Either<JoinProposalFailure, Unit>> declineProposal(
      User connectedUser,
      String joinProposalId,
      );

  Future<Either<JoinProposalFailure, Unit>> acceptProposal(
      User connectedUser,
      String joinProposalId,
      );

  Future<Either<JoinProposalFailure, Unit>> cancelProposal(
    User connectedUser,
    String joinProposalId,
  );

  Future<Either<JoinProposalFailure, List<JoinProposal>>> findPendingProposalsByFamily(
      Family family,
      );

  Future<Either<JoinProposalFailure, Option<JoinProposal>>> findPendingByUser(
    User connectedUser,
  );

  Future<Either<JoinProposalFailure, List<JoinProposal>>> findArchivedByUser(
    User connectedUser,
  );
}
