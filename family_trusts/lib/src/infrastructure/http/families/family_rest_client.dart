import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/families/create_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'family_rest_client.g.dart';

@RestApi()
abstract class FamilyRestClient {
  factory FamilyRestClient(Dio dio) = _FamilyRestClient;

  @GET("/families")
  Future<List<FamilyDTO>> findMatchingFamiliesByMemberIdQuery(
    @Query("memberId") String memberId,
  );

  @GET("/families/available")
  Future<List<FamilyDTO>> findAvailableFamiliesByNameQuery(
    @Query("name") String familyName,
  );

  @POST("/families")
  Future<FamilyDTO> createFamily(@Body() CreateFamilyDTO createFamilyDTO);

  @DELETE("/families/{familyId}/members/{memberId}")
  Future<FamilyDTO> removeMember(
    @Path("familyId") String familyId,
    @Path("memberId") String memberId,
  );
}
