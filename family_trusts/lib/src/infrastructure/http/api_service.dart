import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/infrastructure/http/append_token_interceptor.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/children_lookup_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/persons/person_rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio;

  ApiService._(this._dio);

  static Future<ApiService> init(IAuthFacade authFacade) async {
    await dotenv.load(
      mergeWith: {
        //'API_URL': 'http://192.168.50.204:9004',
        'API_URL': 'https://familytrusts-staging.herokuapp.com',
      },
    );
    final baseUrl = dotenv.env[baseUrlEnvVar];
    final Dio dio = Dio(BaseOptions(baseUrl: baseUrl!))
      ..interceptors.addAll([
        AppendTokenInterceptor(authFacade),
      ]);
    dio.options.headers["Content-Type"] = "application/json";
    // avoid using it in production or do it at your own risks!
    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
    return ApiService._(dio);
  }

  PersonRestClient getPersonRestClient() => PersonRestClient(_dio);

  FamilyRestClient getFamilyRestClient() => FamilyRestClient(_dio);

  JoinProposalRestClient getJoinProposalRestClient() =>
      JoinProposalRestClient(_dio);

  FamilyEventRestClient getFamilyEventRestClient() =>
      FamilyEventRestClient(_dio);

  ChildrenLookupRestClient getChildrenLookupRestClient() =>
      ChildrenLookupRestClient(_dio);
}
