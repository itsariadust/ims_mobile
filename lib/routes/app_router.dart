import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/constants/auth_status.dart';
import 'package:ims_mobile/routes/routes.dart';
import 'package:ims_mobile/viewmodels/auth/auth_check_notifier.dart';
import 'package:ims_mobile/views/pages/main_screen.dart';
import 'package:ims_mobile/views/pages/login.dart';
import 'package:ims_mobile/routes/transitions.dart';

import '../views/pages/splash.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authCheckNotifierProvider);

  final authNotifier = ref.watch(authCheckNotifierProvider.notifier);
  final routerListenable = authNotifier.routerListenable;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final loggingIn = state.matchedLocation == AppRoutes.login;
    final loading = authState.isLoading;

    if (loading && state.matchedLocation != AppRoutes.splash) {
      return AppRoutes.splash;
    }

    if (authState.hasValue && authState.value == AuthStatus.authenticated) {
      if (loggingIn || state.matchedLocation == AppRoutes.splash) {
        return AppRoutes.home;
      }

      return null;
    }

    if (authState.hasValue && authState.value == AuthStatus.unauthenticated) {
      if (state.matchedLocation == AppRoutes.home || state.matchedLocation == AppRoutes.splash) {
        return AppRoutes.login;
      }
    }

    return null;
  }

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: routerListenable,
    redirect: redirectLogic,
    routes: [
      GoRoute(
        path: AppRoutes.splash, builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: MainScreen(),
        ),
      ),
    ]
  );
});