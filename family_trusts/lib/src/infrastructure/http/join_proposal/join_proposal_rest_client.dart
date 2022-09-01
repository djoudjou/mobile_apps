import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/create_join_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'join_proposal_rest_client.g.dart';

@RestApi()
abstract class JoinProposalRestClient {
  factory JoinProposalRestClient(Dio dio) = _JoinProposalRestClient;

  @GET("/proposals/person/{personId}/archived")
  Future<List<JoinFamilyProposalDTO>> findArchivedByPersonId(
    @Path("personId") String personId,
  );

  @GET("/proposals/person/{personId}/pending")
  Future<JoinFamilyProposalDTO> findPendingByPersonId(
    @Path("personId") String personId,
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
}
