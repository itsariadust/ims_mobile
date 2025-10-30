import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ims_mobile/core/constants/api_constants.dart';
import 'package:ims_mobile/core/storage/token_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken;

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

    super.onError(err, handler);
  }
}