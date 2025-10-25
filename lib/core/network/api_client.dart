import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/constants/api_constants.dart';
import 'package:ims_mobile/core/interceptor/auth_interceptor.dart';
import 'package:ims_mobile/core/storage/token_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(tokenStorageProvider);

  return ApiClient(storageService);
});

class ApiClient {
  final Dio _dio;
  final TokenStorage storage;

  ApiClient(this.storage)
    : _dio = Dio(BaseOptions(
      baseUrl: ApiConstants().baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30)
    )) {
    _dio.interceptors.add(AuthInterceptor(_dio, storage));
  }

  Dio get dio => _dio;
}