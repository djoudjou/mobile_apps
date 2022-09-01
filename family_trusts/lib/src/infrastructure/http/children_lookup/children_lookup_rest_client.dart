import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_details_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/create_child_lookup_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'children_lookup_rest_client.g.dart';

@RestApi()
abstract class ChildrenLookupRestClient {
  factory ChildrenLookupRestClient(Dio dio) = _ChildrenLookupRestClient;

  @GET("/childrenlookup/family/{familyId}/inprogress")
  Future<List<ChildLookupDTO>> findInProgressByFamilyId(
    @Path("familyId") String familyId,
  );

  @GET("/childrenlookup/family/{familyId}/past")
  Future<List<ChildLookupDTO>> findPastByFamilyId(
    @Path("familyId") String familyId,
  );

  @GET("/childrenlookup/{childrenLookupId}")
  Future<ChildLookupDetailsDTO> findChildrenLookupDetailsById(
    @Path("childrenLookupId") String childrenLookupId,
  );

  @POST("/childrenlookup")
  Future<FamilyDTO> create(@Body() CreateChildLookupDTO createChildLookupDTO);

  @PUT("/childrenlookup/{childLookupId}/cancel/{issuerId}")
  Future<FamilyDTO> cancel(
    @Path("childLookupId") String childLookupId,
    @Path("issuerId") String issuerId,
  );
}
