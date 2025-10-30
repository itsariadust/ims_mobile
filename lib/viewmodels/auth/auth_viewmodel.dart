import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/auth_repository.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/viewmodels/user/user_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, User?>(() => AuthViewModel());

// Auth ViewModel
class AuthViewModel extends AsyncNotifier<User?> {
  late final AuthRepository _authRepo;

  @override
  FutureOr<User?> build() async {
    // Called when provider is first read (used by splash)
    _authRepo = ref.read(authRepositoryProvider);
    final result = await _authRepo.getSession();
    if (result is Success<Session?>) {
      return result.value?.user;
    }
    return null;
  }

  Future<Result<User>> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _authRepo.login(email, password);

    if (result is Success<User>) {
      state = AsyncData(result.value);
    } else if (result is FailureResult<User>) {
      state = AsyncError(result.failure, StackTrace.current);
    }

    return result;
  }

  Future<void> logout() async {
    await _authRepo.logout();
    state = const AsyncData(null);
  }
}