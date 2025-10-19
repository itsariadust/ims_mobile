import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ims_mobile/core/constants/api_constants.dart';
import 'package:ims_mobile/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    if (kDebugMode) {
      debugPrint('--> ${options.method} ${options.uri}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Data: ${options.data}');
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        debugPrint('Response Data: ${response.data}');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Logging Error
    if (kDebugMode) {
      debugPrint('<-- Error: ${err.message}');
      debugPrint('Status Code: ${err.response?.statusCode}');
    }

    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await storage.getRefreshToken();
        if (refreshToken != null) {
          final newTokens = await _getNewTokens(refreshToken);

          await storage.saveAccessToken(newTokens['accessToken']!);
          await storage.saveRefreshToken(newTokens['refreshToken']!);

          final opts =  err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $refreshToken';

          final response = await dio.fetch(opts);
          return handler.resolve(response);
        }
      } catch (e) {
        await storage.clearAll();
      }
    }
    super.onError(err, handler);
  }

  Future<Map<String, String>> _getNewTokens(String refreshToken) async {
    final response = await dio.post(
      ApiConstants.keycloakUrl,
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client-id': 'ims-frontend-test'
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType
      ),
    );

    return {
      'accessToken': response.data['access_token'] as String,
      'refreshToken': response.data['refresh_token'] as String,
    };
  }
}