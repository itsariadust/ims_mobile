import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/routes/routes.dart' show AppRoutes;
import 'package:ims_mobile/viewmodels/auth/auth_viewmodel.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      authViewModelProvider,
          (_, next) {
        next.whenData((user) {
          if (user != null) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.login);
          }
        });
      },
    );

    ref.watch(authViewModelProvider);

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
