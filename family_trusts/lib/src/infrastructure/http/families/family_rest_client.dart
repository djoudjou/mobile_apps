import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/families/child_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/create_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/trust_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_child_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_trust_person_dto.dart';
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

  @GET("/families/{familyId}")
  Future<FamilyDTO> findFamilyByIdQuery(@Path("familyId") String familyId);

  @DELETE("/families/{familyId}/members/{memberId}")
  Future<FamilyDTO> removeMember(
    @Path("familyId") String familyId,
    @Path("memberId") String memberId,
  );

  @POST("/families/{familyId}/children")
  Future<FamilyDTO> createChild(
    @Path("familyId") String familyId,
    @Body() UpdateChildDTO child,
  );

  @PUT("/families/{familyId}/children/{childId}")
  Future<FamilyDTO> updateChild(
    @Path("familyId") String familyId,
    @Path("childId") String childId,
    @Body() UpdateChildDTO child,
  );

  @DELETE("/families/{familyId}/children/{childId}")
  Future<FamilyDTO> deleteChild(
    @Path("familyId") String familyId,
    @Path("childId") String childId,
  );

  @POST("/families/{familyId}/locations")
  Future<FamilyDTO> createLocation(
    @Path("familyId") String familyId,
    @Body() UpdateLocationDTO location,
  );

  @PUT("/families/{familyId}/locations/{locationId}")
  Future<FamilyDTO> updateLocation(
    @Path("familyId") String familyId,
    @Path("locationId") String locationId,
    @Body() UpdateLocationDTO location,
  );

  @DELETE("/families/{familyId}/locations/{locationId}")
  Future<FamilyDTO> deleteLocation(
    @Path("familyId") String familyId,
    @Path("locationId") String locationId,
  );

  @POST("/families/{familyId}/trust-persons")
  Future<FamilyDTO> createTrustPerson(
    @Path("familyId") String familyId,
    @Body() UpdateTrustPersonDTO trustPerson,
  );

  @PUT("/families/{familyId}/trust-persons/{trustPersonId}")
  Future<FamilyDTO> updateTrustPerson(
    @Path("familyId") String familyId,
    @Path("trustPersonId") String trustPersonId,
    @Body() UpdateTrustPersonDTO trustPerson,
  );

  @DELETE("/families/{familyId}/trust-persons/{trustPersonId}")
  Future<FamilyDTO> deleteTrustPerson(
    @Path("familyId") String familyId,
    @Path("trustPersonId") String trustPersonId,
  );

  @GET("/families/{familyId}/children")
  Future<List<ChildDTO>> findChildrenByFamilyIdQuery(
    @Path("familyId") String familyId,
  );

  @GET("/families/{familyId}/locations")
  Future<List<LocationDTO>> findLocationsByFamilyIdQuery(
    @Path("familyId") String familyId,
  );

  @GET("/families/{familyId}/trust-persons")
  Future<List<TrustPersonDTO>> findTrustPersonsByFamilyIdQuery(
    @Path("familyId") String familyId,
  );
}
