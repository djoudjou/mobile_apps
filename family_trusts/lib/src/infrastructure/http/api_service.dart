import 'package:connectivity/connectivity.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/infrastructure/http/append_token_interceptor.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/children_lookup_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/dio_connectivity_request_retrier.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/family_event/family_event_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/join_proposal/join_proposal_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/persons/person_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/retry_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio;

  ApiService._(this.dio);

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

    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    // avoid using it in production or do it at your own risks!
    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
    return ApiService._(dio);
  }

  PersonRestClient getPersonRestClient() => PersonRestClient(dio);

  FamilyRestClient getFamilyRestClient() => FamilyRestClient(dio);

  JoinProposalRestClient getJoinProposalRestClient() =>
      JoinProposalRestClient(dio);

  FamilyEventRestClient getFamilyEventRestClient() =>
      FamilyEventRestClient(dio);

  ChildrenLookupRestClient getChildrenLookupRestClient() =>
      ChildrenLookupRestClient(dio);
}
