import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/infrastructure/http/http_failure.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/base_rest_client_http.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_dto.dart';
import 'package:http/http.dart' as http;

class JoinProposalRestClientHttp extends BaseRestClient {
  JoinProposalRestClientHttp(super.baseUrl, super.authFacade);

  Future<Either<HttpFailure, Option<JoinFamilyProposalDTO>>>
      findPendingByPersonId(String personId) async {
    try {
      var response = await http.get(
          Uri.parse("$baseUrl/proposals/person/$personId/pending"),
          headers: {
            'Authorization': await authHeader(),
          });

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final JoinFamilyProposalDTO joinFamilyProposal =
            JoinFamilyProposalDTO.fromJson(
                responseJson as Map<String, dynamic>);

        return right(some(joinFamilyProposal));
      } else if (response.statusCode == 404) {
        return right(none());
      } else if (response.statusCode == 401 && response.statusCode == 403) {
        return left(const HttpFailure.insufficientPermission());
      } else {
        log("Error response $responseJson");
        return left(const HttpFailure.technicalError());
      }
    } catch (e) {
      log("Error $e");
      return left(const HttpFailure.technicalError());
    }
  }

  Future<Either<HttpFailure, List<JoinFamilyProposalDTO>>>
      findArchivedByPersonId(String personId) async {
    try {
      var response = await http.get(
          Uri.parse("$baseUrl/proposals/person/$personId/archived"),
          headers: {
            'Authorization': await authHeader(),
          });

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<JoinFamilyProposalDTO> joinFamilyProposals =
            (responseJson as List<dynamic>)
                .map((dynamic elt) =>
                    JoinFamilyProposalDTO.fromJson(elt as Map<String, dynamic>))
                .toList();

        return right(joinFamilyProposals);
      } else if (response.statusCode == 401 && response.statusCode == 403) {
        return left(const HttpFailure.insufficientPermission());
      } else {
        log("Error response $responseJson");
        return left(const HttpFailure.technicalError());
      }
    } catch (e) {
      log("Error $e");
      return left(const HttpFailure.technicalError());
    }
  }

/*

  @GET("/proposals/family/{familyId}")
  Future<List<JoinFamilyProposalDTO>> findPendingByFamilyId(
      @Path("familyId") String familyId,
      );

  @POST("/proposals")
  Future<JoinFamilyProposalDTO> create(
      @Body() CreateJoinFamilyProposalDTO createJoinFamilyProposalDTO,
      );

  @PUT("/proposals/{joinFamilyProposalId}/cancel/{issuerId}")
  Future<JoinFamilyProposalDTO> cancel(
      @Path("joinFamilyProposalId") String joinFamilyProposalId,
      @Path("issuerId") String issuerId,
      );

  @PUT("/proposals/{joinFamilyProposalId}/decline/{memberId}")
  Future<JoinFamilyProposalDTO> decline(
      @Path("joinFamilyProposalId") String joinFamilyProposalId,
      @Path("memberId") String memberId,
      );

  @PUT("/proposals/{joinFamilyProposalId}/accept/{memberId}")
  Future<JoinFamilyProposalDTO> accept(
      @Path("joinFamilyProposalId") String joinFamilyProposalId,
      @Path("memberId") String memberId,
      );
      */
}
