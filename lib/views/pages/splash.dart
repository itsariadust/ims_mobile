import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/constants/auth_status.dart';
import 'package:ims_mobile/viewmodels/auth/auth_check_notifier.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  void redirect(BuildContext context, WidgetRef ref, AsyncValue<AuthStatus> authStatus) {
    if (authStatus.isLoading) return;

    final router = GoRouter.of(context);
    final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();

    if (currentRoute == '/splash') {
      if (authStatus.value == AuthStatus.authenticated) {
        router.go('/home');
      } else {
        router.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authCheckNotifierProvider);

    ref.listen<AsyncValue<AuthStatus>>(authCheckNotifierProvider, (_, next) {
      redirect(context, ref, next);
    });
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...'),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}