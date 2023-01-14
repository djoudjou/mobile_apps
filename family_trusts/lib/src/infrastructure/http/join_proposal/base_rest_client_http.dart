import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'dart:async';

import '../../../helper/log_mixin.dart';

abstract class BaseRestClient with LogMixin  {
  final String baseUrl;
  final IAuthFacade authFacade;

  BaseRestClient(this.baseUrl, this.authFacade);

  Future<String?> getToken() async {
    final result = await authFacade.getToken();
    var token = result.fold(
      (failure) => null,
      (t) => t,
    );
    return token;
  }

  Future<String> authHeader() async {
    var token = await getToken();
    return "Bearer $token";
  }
}
