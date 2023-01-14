import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/api_service_http.dart';
import 'package:familytrusts/src/infrastructure/http/http_failure.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/create_join_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IJoinProposalRepository)
class ApiJoinProposalRepository
    with LogMixin
    implements IJoinProposalRepository {
  final ApiServiceHttp _apiServiceHttp;
  final ApiService _apiService;

  ApiJoinProposalRepository(this._apiService, this._apiServiceHttp);

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
      final Either<HttpFailure, List<JoinFamilyProposalDTO>>
          eitherJoinFamilyProposals = await _apiServiceHttp
              .getJoinProposalRestClient()
              .findArchivedByPersonId(connectedUser.id!);

      return eitherJoinFamilyProposals.fold(
          (httpFailure) => left(
                httpFailure.maybeMap(
                  insufficientPermission: (_) =>
                      const JoinProposalFailure.insufficientPermission(),
                  orElse: () => const JoinProposalFailure.serverError(),
                ),
              ),
          (result) => right(result.map((f) => f.toDomain()).toList()));
    } catch (e) {
      log("error in findArchivedByUser method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }

  @override
  Future<Either<JoinProposalFailure, Option<JoinProposal>>> findPendingByUser(
      User connectedUser) async {
    try {
      final Either<HttpFailure, Option<JoinFamilyProposalDTO>> result =
          await _apiServiceHttp
              .getJoinProposalRestClient()
              .findPendingByPersonId(connectedUser.id!);

      return result.fold(
          (httpFailure) => left(
                httpFailure.maybeMap(
                  insufficientPermission: (_) =>
                      const JoinProposalFailure.insufficientPermission(),
                  orElse: () => const JoinProposalFailure.serverError(),
                ),
              ),
          (success) => success.fold(
              () => right(none()), (a) => right(some(a.toDomain()))));
    } on Exception catch (e) {
      log("catchError in findPendingByUser method : $e");
      return left(const JoinProposalFailure.serverError());
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

  @override
  Future<Either<JoinProposalFailure, Unit>> acceptProposal(
      User connectedUser, String joinProposalId) async {
    try {
      await _apiService
          .getJoinProposalRestClient()
          .accept(joinProposalId, connectedUser.id!);
      return right(unit);
    } catch (e) {
      log("error in acceptProposal method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }

  @override
  Future<Either<JoinProposalFailure, Unit>> declineProposal(
      User connectedUser, String joinProposalId) async {
    try {
      await _apiService
          .getJoinProposalRestClient()
          .decline(joinProposalId, connectedUser.id!);
      return right(unit);
    } catch (e) {
      log("error in declineProposal method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }

  @override
  Future<Either<JoinProposalFailure, List<JoinProposal>>>
      findPendingProposalsByFamily(Family family) async {
    try {
      final List<JoinFamilyProposalDTO> joinFamilyProposals = await _apiService
          .getJoinProposalRestClient()
          .findPendingByFamilyId(family.id!);

      return right(joinFamilyProposals.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in findPendingProposalsByFamily method : $e");
      return left(const JoinProposalFailure.serverError());
    }
  }
}
