import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/auth_repository.dart';
import 'package:ims_mobile/core/errors/failures.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/viewmodels/auth/auth_check_notifier.dart';
import 'package:ims_mobile/viewmodels/user/user_viewmodel.dart';

// Auth state
class AuthState {
  final String email;
  final String password;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final String? generalError;

  AuthState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.generalError,
  });

  AuthState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? generalError,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      // Use null to clear errors, or the new error message
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
    );
  }
}

// Provider for AuthViewModel
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

// Auth ViewModel
class AuthViewModel extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return AuthState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> login() async {
    if (!_validateForm()) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      emailError: null,
      passwordError: null,
      generalError: null,
    );

    final result = await _authRepository.login(
      username: state.email,
      password: state.password,
    );

    state = state.copyWith(isLoading: false);

    switch (result) {
      case Success(value: final isSuccess):
        if (isSuccess) {
          final authNotifier = ref.read(authCheckNotifierProvider.notifier);
          authNotifier.setAuthenticated();
          ref.read(userViewModelProvider.notifier).refreshProfile();
        }
        break;
      case FailureResult(failure: final failure):
        if (failure is AuthFailure) {
          // This handles "wrong credentials" and sets errors on the fields
          _handleAuthFailure(failure.message);
        } else if (failure is NetworkFailure) {
          // General Network error (e.g., no internet)
          state = state.copyWith(
              generalError: 'Connection failed. Check internet.');
        } else {
          // Other Server or Unknown failures
          state = state.copyWith(generalError: failure.message);
        }
        break;
    }
  }

  bool _validateForm() {
    bool isValid = true;
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = 'Email cannot be empty.';
      isValid = false;
    }
    if (state.password.isEmpty) {
      passwordError = 'Password cannot be empty.';
      isValid = false;
    }

    // Update state with local validation errors (if any)
    if (!isValid) {
      state = state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        generalError: null, // Clear any previous server error
      );
    }

    return isValid;
  }

  void _handleAuthFailure(String errorMessage) {
    state = state.copyWith(
      emailError: 'Invalid email.',
      passwordError: 'Invalid password.',
      generalError: errorMessage,
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    ref.read(userViewModelProvider.notifier).clearProfile();
    final authNotifier = ref.read(authCheckNotifierProvider.notifier);
    authNotifier.setUnauthenticated();
  }
}