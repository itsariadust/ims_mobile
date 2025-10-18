import 'package:dio/dio.dart';
import 'package:ims_mobile/core/storage/token_storage.dart';
import '../../core/storage/token_pair.dart';

class AuthService {
  final Dio _dio;
  final SecureTokenStorage _secureTokenStorage;

  AuthService(this._dio, this._secureTokenStorage);

  static const baseUrl = 'http://10.0.2.2:9090/realms/ims-realm/protocol/openid-connect/token';
  static const clientId = 'ims-frontend-test';

  Future<TokenPair> login(String username, String password) async {
    final response = await _dio.post(
      baseUrl,
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: {
        'client_id': clientId,
        'grant_type': 'password',
        'username': username,
        'password': password,
      },
    );

    final data = response.data;
    final tokenPair = TokenPair(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
    );

    await _secureTokenStorage.saveTokens(tokenPair);
    return tokenPair;
  }

  Future<TokenPair?> refresh(String refreshToken) async {
    try {
      final response = await _dio.post(
        baseUrl,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          'client_id': clientId,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );

      final data = response.data;
      final tokenPair = TokenPair(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );

      await _secureTokenStorage.saveTokens(tokenPair);
      return tokenPair;
    } catch (e) {
      await _secureTokenStorage.clear();
      return null;
    }
  }

  Future<TokenPair?> loadTokens() async {
    final tokenPair = await _secureTokenStorage.loadTokens();
    if ( tokenPair?.accessToken != null && tokenPair?.refreshToken != null) {
      return tokenPair;
    }
    return null;
  }

  Future<void> logout() async {
    await _secureTokenStorage.clear();
  }
}
