import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:familytrusts/src/infrastructure/http/append_token_interceptor.dart';
import 'package:familytrusts/src/infrastructure/http/person_rest_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio;

  ApiService._(this._dio);

  static Future<ApiService> init(IAuthFacade authFacade) async {
    await dotenv.load(
      mergeWith: {
        'API_URL': 'localhost:9004',
      },
    );
    final baseUrl = dotenv.env[baseUrlEnvVar];
    final Dio dio = Dio(BaseOptions(baseUrl: baseUrl!))
      ..interceptors.addAll([
        AppendTokenInterceptor(authFacade),
      ]);
    dio.options.headers["Content-Type"] = "application/json";
    return ApiService._(dio);
  }

  PersonRestClient getPersonRestClient() => PersonRestClient(_dio);
}
