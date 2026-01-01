import 'package:chatapp/app/core/network/ch_interceptors.dart';
import 'package:dio/dio.dart';

class DioClient {
  static Dio getInstance() {
    final dio = Dio();

    dio.interceptors.clear();
    dio.interceptors.add(ChInterceptors());

    return dio;
  }
}
