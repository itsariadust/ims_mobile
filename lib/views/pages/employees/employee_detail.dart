import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/viewmodels/employee/employee_detail_viewmodel.dart';

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
            const SizedBox(height: 24), // Spacing before the button.
            FilledButton.icon(
              onPressed: () { /* TODO: Implement edit action */ },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Employee'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
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
}