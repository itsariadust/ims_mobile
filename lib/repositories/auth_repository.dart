import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:ims_mobile/core/storage/token_storage.dart';
import 'package:ims_mobile/services/auth_service.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/core/errors/failures.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storageService = ref.watch(tokenStorageProvider);

  return AuthRepository(authService, storageService);
});

class AuthRepository {
  final AuthService _authService;
  final TokenStorage _tokenStorage;

  AuthRepository(this._authService, this._tokenStorage);

  Future<Result<bool>> login({
    required String username,
    required String password
  }) async {
    try {
      final loginResponse = await _authService.login(
        username: username, password: password
      );

      await _tokenStorage.saveAccessToken(loginResponse.accessToken);
      await _tokenStorage.saveRefreshToken(loginResponse.refreshToken);

      return Success(true);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return FailureResult(AuthFailure(message: 'Invalid username or password.'));
      }
      return FailureResult(ServerFailure(message: e.message ?? 'An unknown server error occurred.'));
    } catch (e) {
      return FailureResult(AuthFailure(message: 'An unexpected error occurred during login.'));
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken != null) {
      await _authService.logout(refreshToken);
    }

    await _tokenStorage.clearAll();
  }

  Future<bool?> checkToken() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return false;
    }

    if (!JwtDecoder.isExpired(accessToken)) {
      return true;
    }

    if (!JwtDecoder.isExpired(refreshToken)) {
      return null;
    }

    return false;
  }

  Future<bool> silentRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      return false;
    }

    try {
      final Map<String, String> newTokens = await _authService.refreshTokens(refreshToken);

      await _tokenStorage.saveAccessToken(newTokens['accessToken']!);
      await _tokenStorage.saveRefreshToken(newTokens['refreshToken']!);

      return true;
    } catch (e) {
      await _tokenStorage.clearAll();
      return false;
    }
  }

  Future<String?> getUserIdFromToken() async {
    final accessToken = await _tokenStorage.getAccessToken();

    if (accessToken == null) {
      return null;
    }

    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      return decodedToken['sub'] as String?;
    } catch (e) {
      print('Error decoding JWT to get user ID: $e');
      return null;
    }
  }
}