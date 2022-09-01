import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/create_join_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IJoinProposalRepository)
class ApiJoinProposalRepository
    with LogMixin
    implements IJoinProposalRepository {
  final ApiService _apiService;

  ApiJoinProposalRepository(this._apiService);

  @override
  Future<Either<JoinProposalFailure, Unit>> cancelProposal(
    User connectedUser,
    String joinProposalId,
  ) async {
    try {
      final JoinFamilyProposalDTO result = await _apiService
          .getJoinProposalRestClient()
          .cancel(joinProposalId, connectedUser.id!);

      log("sendProposal > $result");
      return right(unit);
    } catch (e) {
      log("error in sendProposal method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }

  @override
  Future<Either<JoinProposalFailure, List<JoinProposal>>> findArchivedByUser(
    User connectedUser,
  ) async {
    try {
      final List<JoinFamilyProposalDTO> joinFamilyProposals = await _apiService
          .getJoinProposalRestClient()
          .findArchivedByPersonId(connectedUser.id!);

      return right(joinFamilyProposals.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in findArchivedByUser method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }

  @override
  Future<Either<JoinProposalFailure, Option<JoinProposal>>> findPendingByUser(User connectedUser) async {
    try {
      final JoinFamilyProposalDTO joinFamilyProposal = await _apiService
          .getJoinProposalRestClient()
          .findPendingByPersonId(connectedUser.id!);

      return right(some(joinFamilyProposal.toDomain()));
    } catch (e) {
      if(e is DioError && e.response?.statusCode == 404) {
        return right(none());
      } else {
        log("error in findPendingByUser method : $e");
        return left(const JoinProposalFailure.serverError());
      }
    }
  }

  @override
  Future<Either<JoinProposalFailure, Unit>> sendProposal(
    User connectedUser,
    Family family,
  ) async {
    try {
      final CreateJoinFamilyProposalDTO createJoinFamilyProposalDTO =
          CreateJoinFamilyProposalDTO(
        issuerId: connectedUser.id!,
        familyId: family.id!,
      );
      final JoinFamilyProposalDTO result = await _apiService
          .getJoinProposalRestClient()
          .create(createJoinFamilyProposalDTO);

      log("sendProposal > $result");
      return right(unit);
    } catch (e) {
      log("error in sendProposal method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }


}
