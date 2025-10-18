import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ims_mobile/core/storage/token_pair.dart';

final storage = FlutterSecureStorage();

class SecureTokenStorage {
  // Save tokens
  Future<void> saveTokens(TokenPair tokens) async {
    await storage.write(key: 'access_token', value: tokens.accessToken);
    await storage.write(key: 'refresh_token', value: tokens.refreshToken);
  }

  // return TokenPair
  Future<TokenPair?> loadTokens() async {
    final access = await storage.read(key: 'access_token');
    final refresh = await storage.read(key: 'refresh_token');
    if (access != null && refresh != null) {
      return TokenPair(accessToken: access, refreshToken: refresh);
    }
    return null;
  }

  // Get either the access or refresh token
  Future<String?> getAccessToken() => storage.read(key: 'access_token');
  Future<String?> getRefreshToken() => storage.read(key: 'refresh_token');

  // Logout and clear tokens
  Future<void> clear() async => await storage.deleteAll();
}