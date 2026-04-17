import 'package:dio/dio.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/core/network/api_client.dart';
import 'package:login_demo/core/network/interceptions/auth_interceptors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiUtil {
  ApiUtil._();
  static Dio? dio;
  static Dio getDio() {
    if (dio == null) {
      dio = Dio();
      dio!.options.connectTimeout = AppConfigs.apiTimeout;
      dio!.options.sendTimeout = AppConfigs.apiTimeout;
      dio!.options.receiveTimeout = AppConfigs.apiTimeout;
      dio!.interceptors.add(AuthInterceptors());
      dio!.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          requestBody: true,
          responseBody: true,
          compact: false,
        ),
      );
    }
    return dio!;
  }

  static ApiClient get apiClient {
    // ignore: non_constant_identifier_names
    final apiClient = ApiClient(getDio(), baseUrl: AppConfigs.baseUrl);
    return apiClient;
  }
}
