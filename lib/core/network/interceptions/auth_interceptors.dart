import 'package:dio/dio.dart';
import 'package:login_demo/core/constants/key_constants.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/navigator/app_router.dart';

class AuthInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageHelper.instance.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final errorKey = err.response?.data?['error_key'];

    if (err.response?.statusCode == 401) {
      if (errorKey == KeyConstants.errInvalidAccessToken) {
        await _forceLogout();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  Future<void> _forceLogout() async {
    await SecureStorageHelper.instance.clearAccessToken();
    AppRouter.markUnauthenticated();
  }
}
