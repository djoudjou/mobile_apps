import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_dto.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_mark_as_read_dto.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_remove_dto.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_events_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'family_event_rest_client.g.dart';

@RestApi()
abstract class FamilyEventRestClient {
  factory FamilyEventRestClient(Dio dio) = _FamilyEventRestClient;

  @PUT("/events/{familyEventId}/read")
  Future<FamilyEventDTO> markAsRead(
    @Path("familyEventId") String familyEventId,
    @Body() FamilyEventMarkAsReadDTO familyEventMarkAsReadDTO,
  );

  @DELETE("/events/{familyEventId}")
  Future<void> remove(
    @Path("familyEventId") String familyEventId,
    @Body() FamilyEventRemoveDTO familyEventRemoveDTO,
  );

  @GET("/events/member/{memberId}")
  Future<FamilyEventsDTO> findEventsByMemberId(
    @Path("memberId") String memberId,
  );
}
