import 'package:chatapp/app/core/network/ch_interceptors.dart';
import 'package:chatapp/app/core/utils/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChEnvironment {
  static String currentEnv = "";
  static String apiUrl = "";
  static Future<void> initialize(String env) async {
    WidgetsFlutterBinding.ensureInitialized();

    currentEnv = env;

    if (env == 'dev') {
      apiUrl = 'http://192.168.181.76:8081';
    } else if (env == 'uat') {
      apiUrl =
          'https://dentory-api-dev-ckhxaagjfxg3f5fz.centralus-01.azurewebsites.net';
    } else if (env == 'prod') {
      apiUrl = 'https://api2.silvertop.com.au/api';
    }

    AppUrls.baseUrl = apiUrl;

    final dio = Dio();
    dio.interceptors.add(ChInterceptors());
  }
}
