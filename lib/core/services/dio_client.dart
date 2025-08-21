// lib/core/services/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final DioClient _defaultInstance = DioClient._internal(
    baseUrl: 'https://api-astronet.zwoastro.com',
  );

  static final DioClient _bannerInstance = DioClient._internal(
    baseUrl: 'https://api.zwoastro.com',
  );

  factory DioClient() => _defaultInstance;
  factory DioClient.bannerApi() => _bannerInstance;

  late final Dio dio;

  DioClient._internal({required String baseUrl}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['X-params'] = {
            "platform": "MacIntel",
            "model":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
            "os_version": "",
            "app_version":
                "5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
            "channel": "web",
            "country_code": "en",
            "zwo_app": "astronet"
          };
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('Dio error: $e');
        handler.next(e);
      },
    ));
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) {
    return dio.post(path, data: data);
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) {
    return dio.get(path, queryParameters: params);
  }
}
