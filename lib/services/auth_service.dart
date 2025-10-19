import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/constants/api_constants.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/auth_tokens_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AuthService(apiClient);
});

class AuthService {
  final Dio _dio;
  AuthService(ApiClient apiClient) : _dio = apiClient.dio;

  static const String _tokenEndpoint = ApiConstants.keycloakUrl;

  // Login
  Future<AuthTokens> login({
    required String username,
    required String password
  }) async {
    try {
      final response = await _dio.post(
        _tokenEndpoint,
        data: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': 'ims-frontend-test'
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        ),
      );
      return AuthTokens.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(
        ApiConstants.logoutEndpoint,
        data: {
          'client_id': 'ims-frontend-test',
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, String>> refreshTokens(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.keycloakUrl,
      data: {
        'client_id': 'ims-frontend-test',
        'refresh_token': refreshToken,
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
