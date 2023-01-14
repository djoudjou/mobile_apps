import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'join_proposal/join_proposal_rest_client_http.dart';

class ApiServiceHttp {
  final String baseUrl;

  ApiServiceHttp._(this.baseUrl);

  static Future<ApiServiceHttp> init(IAuthFacade authFacade) async {
    await dotenv.load(
      mergeWith: {
        //'API_URL': 'http://192.168.50.204:9004',
        'API_URL': 'https://familytrusts-staging.herokuapp.com',
      },
    );
    final baseUrl = dotenv.env[baseUrlEnvVar];

    return ApiServiceHttp._(baseUrl!);
  }

  JoinProposalRestClientHttp getJoinProposalRestClient() =>
      JoinProposalRestClientHttp(baseUrl, getIt<IAuthFacade>());
}
