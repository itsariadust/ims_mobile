import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/storage/token_pair.dart';
import 'package:ims_mobile/views/pages/main_screen.dart';
import 'package:ims_mobile/views/viewmodels/auth_viewmodel.dart';
import 'package:ims_mobile/views/pages/login.dart';

import '../pages/splash.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<bool>(true);

  ref.listen<AsyncValue<TokenPair?>>(authViewModelProvider, (_, __) {
    notifier.value =  !notifier.value;
  });

  return GoRouter(
      initialLocation: '/splash',
      refreshListenable: notifier,
      redirect: (context, state) {
        final authState = ref.watch(authViewModelProvider);

        final isCheckingAuth = authState.isLoading;
        final isLoggingIn = state.uri.path == '/login';
        final isGoingToSplash = state.uri.path == '/splash';
        // if (authState.isLoading) return null;

        if (isCheckingAuth) {
          // While authentication is being checked (initial build of AuthViewModel),
          // ensure the user stays on the splash screen.
          return isGoingToSplash ? null : '/splash';
        }

        return authState.when(
          error: (_, __) => '/login', // Unrecoverable error -> Login
          loading: () => '/splash',    // Should be caught above, but safe fallback
          data: (tokenPair) {
            final isAuthenticated = tokenPair != null;

            if (!isAuthenticated) {
              // Unauthenticated: Redirect to login unless already going there.
              return isLoggingIn || isGoingToSplash ? '/login' : null;
            }

            // Authenticated: Redirect to home ('/') unless already going there.
            if (isAuthenticated) {
              return (isLoggingIn || isGoingToSplash) ? '/' : null;
            }

            return null; // Stay on the current page if it's an authenticated one
          },
        );
      },
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/', builder: (_, __) => const MainScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/dashboard', builder: (_, __) => const MainScreen()),
      ]
  );
});