import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/http/families/create_family_dto.dart';
import 'package:familytrusts/src/domain/http/families/family_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'family_rest_client.g.dart';

@RestApi()
abstract class FamilyRestClient {
  factory FamilyRestClient(Dio dio) = _FamilyRestClient;

  @GET("/families")
  Future<List<FamilyDTO>> findAll();

  @GET("/families")
  Future<List<FamilyDTO>> findMatchingFamiliesByName(
    @Query("name") String name,
  );

  @GET("/families")
  Future<List<FamilyDTO>> findMatchingFamiliesByMemberIdQuery(
    @Query("memberId") String memberId,
  );

  @GET("/families/match")
  Future<List<FamilyDTO>> findFamilyByNameQuery(
    @Query("name") String familyName,
  );

  @GET("/families/available")
  Future<List<FamilyDTO>> findAvailableFamiliesByNameQuery(
    @Query("name") String familyName,
  );

  @GET("/families/{familyId}")
  Future<FamilyDTO> findFamilyById(@Path("familyId") String familyId);

  @POST("/families")
  Future<FamilyDTO> createFamily(@Body() CreateFamilyDTO createFamilyDTO);

  @PUT("/families/{familyId}")
  Future<FamilyDTO> updateFamilyName(
    @Path("familyId") String familyId,
    @Query("familyName") String familyName,
  );

  @DELETE("/families/{familyId}/members/{memberId}")
  Future<FamilyDTO> removeMember(
    @Path("familyId") String familyId,
    @Path("memberId") String memberId,
  );
}
