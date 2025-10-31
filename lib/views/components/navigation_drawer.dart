import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/routes/routes.dart';
import 'package:ims_mobile/viewmodels/auth/auth_viewmodel.dart';
import 'package:ims_mobile/viewmodels/user/user_viewmodel.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Drawer(
      child: ListView(
        children: [
          userProfileAsyncValue.when(
            loading: () => DrawerHeader(
              child: CircularProgressIndicator(),
            ),
            error: (err, stack) => UserAccountsDrawerHeader(
              accountName: Text('Error Loading'),
              accountEmail: Text('Could not load user data.'),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.error),
            ),
            data: (employee) {
              return UserAccountsDrawerHeader(
                accountName: Text('${employee?.fullName}'),
                accountEmail: Text(employee!.email),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            onTap: () {
              authViewModel.logout();
              context.go(AppRoutes.login);
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          )
        ],
      )
    );
  }
}