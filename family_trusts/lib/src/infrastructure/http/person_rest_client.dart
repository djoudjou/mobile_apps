import 'package:dio/dio.dart';
import 'package:familytrusts/src/infrastructure/http/login_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/registred_person_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'person_rest_client.g.dart';

@RestApi()
abstract class PersonRestClient {
  factory PersonRestClient(Dio dio) = _PersonRestClient;

  @GET("/persons")
  Future<List<PersonDTO>> findAll();

  @GET("/persons/{id}")
  Future<PersonDTO> findPersonById(@Path("id") String personId);

  @POST("/persons")
  Future<RegisterPersonResponseDTO> createPerson(@Body() PersonDTO person);

  @PUT("/persons/{id}")
  Future<PersonDTO> update(@Path("id") String personId, @Body() PersonDTO person);

  @PUT("/persons/{id}/login")
  Future<PersonDTO> login(
    @Path("id") String personId,
    @Body() LoginPersonDTO loginPersonDTO,
  );
}
