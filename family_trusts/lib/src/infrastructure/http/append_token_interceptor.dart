import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';

class AppendTokenInterceptor extends Interceptor {
  AppendTokenInterceptor(this._authFacade);

  final IAuthFacade _authFacade;

  static const _exceptions = ['/login', '/forgot-password'];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_exceptions.any(options.path.startsWith)) {
      final token = _authFacade.getSignedInUser().map((a) => a.getIdToken());
      options.headers['Authorization'] = token;
    }

    return super.onRequest(options, handler);
  }
}
