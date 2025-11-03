import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/functions/deactivate_employee.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/viewmodels/employee/employee_detail_viewmodel.dart';
import 'package:ims_mobile/viewmodels/employee/employee_list_viewmodel.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final int employeeId;
  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeDetailAsyncValue = ref.watch(employeeDetailViewModelProvider(employeeId));

    return employeeDetailAsyncValue.when(
      data: (employee) {
        if (employee == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text('Employee not found.'),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.person, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    employee.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.role.substring(0, 1) + employee.role.substring(1).toLowerCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(employee.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () { /* TODO: Implement email action */ },
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Contact Number'),
                  subtitle: Text(employee.contactNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () { /* TODO: Implement call action */ },
                  ),
                ),
                const Divider(),
              ],
            ),
            const SizedBox(height: 24),
            // Edit button
            FilledButton.icon(
              onPressed: () {
                context.pushNamed(
                  'employeeEdit',
                  queryParameters: {
                    'actionType': 'edit'
                  },
                  pathParameters: {
                    'id': employee.id.toString()
                  },
                  extra: employee
                );
                context.pop();
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Employee'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            // Deactivate button
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Deactivate employee?'),
                    content: const Text('Are you sure you want to deactivate this employee?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')
                      ),
                      TextButton(
                        onPressed: () async {
                          await _onDeactivate(context, employee, ref);
                        },
                        child: Text('Yes')
                      ),
                    ]
                  )
                );
              },
              icon: const Icon(Icons.close),
              label: const Text('Deactivate Employee'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text('Error: $err'),
        ),
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _onDeactivate(BuildContext context, Employee employee, WidgetRef ref) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    final result = await deactivateUser(employee.uuid);

    if (!context.mounted) return;

    GoRouter.of(context).pop();

    switch (result) {
      case Success():
        GoRouter.of(context)..pop()..pop();
        ref.refresh(employeeListViewModelProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee deactivated successfully.'))
        );
        break;
      case FailureResult():
        GoRouter.of(context)..pop()..pop();
        ref.refresh(employeeListViewModelProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error deactivating employee.'))
        );
        break;
    }
  }
}