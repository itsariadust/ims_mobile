import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/storage/token_pair.dart';
import 'package:ims_mobile/data/providers/auth_providers.dart';
import 'package:ims_mobile/data/services/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, TokenPair?>(
  AuthViewModel.new
);

class AuthViewModel extends AsyncNotifier<TokenPair?>{
  late final AuthService authService;

  @override
  FutureOr<TokenPair?> build() async {
    authService = ref.watch(authServiceProvider);

    // Load stored tokens
    final stored = await authService.loadTokens();
    if (stored == null) return null;

    // If access token is valid, return it
    if (!JwtDecoder.isExpired(stored.accessToken)) {
      return stored;
    }

    // Otherwise, try refreshing it
    final refreshed = await authService.refresh(stored.refreshToken);
    return refreshed;
  }

  Future<void> login(String username, String password) async {
    try {
      final tokens = await authService.login(username, password);
      state = AsyncData(tokens);
    } on DioException catch (e) {
      rethrow;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }


  Future<void> logout() async {
    await authService.logout();
    state = const AsyncData(null);
  }

  bool get isAuthenticated =>
      state.value != null && !JwtDecoder.isExpired(state.value!.accessToken);
}

