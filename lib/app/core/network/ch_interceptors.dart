import 'dart:convert';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/flavors/ch_environment.dart';
import 'package:dio/dio.dart';

class ChInterceptors extends Interceptor {
  final String baseUrl = ChEnvironment.apiUrl;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.baseUrl = baseUrl;

    final sessionToken = await CommonService.getSessionToken();

    options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    options.headers["Authorization"] = "Bearer $sessionToken";

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is String) {
      try {
        response.data = jsonDecode(response.data);
      } catch (e) {}
    }
    return handler.next(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }
}
