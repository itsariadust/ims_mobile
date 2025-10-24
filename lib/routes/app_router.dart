import 'package:flutter/material.dart';
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
  final authNotifier = ref.watch(authCheckNotifierProvider.notifier);
  final routerListenable = authNotifier.routerListenable;

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: routerListenable,
    routes: [
      GoRoute(
        path: '/splash', builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: MainScreen(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start from the right (x=1.0)
            const end = Offset.zero;      // Slide to the center (x=0.0)
            const curve = Curves.ease;    // Use an easing curve

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        )
      )
    ]
  );
});