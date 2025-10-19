import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/auth_repository.dart';
import 'package:ims_mobile/core/constants/auth_status.dart';

final authCheckNotifierProvider = AsyncNotifierProvider<AuthCheckNotifier, AuthStatus>(
  AuthCheckNotifier.new,
);

class AuthCheckNotifier extends AsyncNotifier<AuthStatus>{
  final ValueNotifier<bool> _routerListenable = ValueNotifier<bool>(false);
  ValueNotifier<bool> get routerListenable => _routerListenable;

  late final AuthRepository _authRepository;

  @override
  Future<AuthStatus> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    _routerListenable.value = !_routerListenable.value;

    return await _checkInitialAuthStatus();
  }

  Future<AuthStatus> _checkInitialAuthStatus() async {
    final status = await _authRepository.checkToken();

    if (status == true) {
      return AuthStatus.authenticated;
    } else if (status == null) {
      final refresh = await _authRepository.silentRefresh();

      return refresh ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } else {
      return AuthStatus.unauthenticated;
    }
  }

  void setAuthenticated() {
    state = AsyncValue.data(AuthStatus.authenticated);
    _routerListenable.value = !_routerListenable.value;
  }

  void setUnauthenticated() {
    state = AsyncValue.data(AuthStatus.unauthenticated);
    _routerListenable.value = !_routerListenable.value;
  }
}