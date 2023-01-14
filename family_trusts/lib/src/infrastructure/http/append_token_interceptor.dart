import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';

class AppendTokenInterceptor extends Interceptor with LogMixin {
  AppendTokenInterceptor(this._authFacade);

  final IAuthFacade _authFacade;

  static const _exceptions = ['/login', '/forgot-password'];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_exceptions.any(options.path.startsWith)) {
      final result = await _authFacade.getToken();
      result.fold(
        (failure) => null,
        (token) => options.headers['Authorization'] = "Bearer $token",
      );
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    log('Dio error!');
    log("DATA: ${err.response?.data}");
    log("HEADERS: ${err.response?.headers}");
    log("STATUS: ${err.response?.statusCode}");

    return handler.next(err); // <--- THE TIP IS HERE
  }
}
