import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _handleLogout();
    }

    handler.next(err);
  }

  void _handleLogout() {
    final context = AppRouter.navigationKey.currentContext;
    if (context == null) return;

    // context.read<AppCubit>().logout();
    // chưa xoá token ở secure storage để tiện cho việc auto-login sau này, chỉ xoá khi user explicitly logout
    AppRouter.navigationKey.currentState?.popUntil((route) => route.isFirst);

    context.replaceNamed(AppRouter.loginRouteName);
  }
}
