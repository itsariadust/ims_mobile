import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/viewmodels/employee/employee_detail_viewmodel.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final int employeeId;
  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeDetailAsyncValue = ref.watch(employeeDetailViewModelProvider(employeeId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: employeeDetailAsyncValue.when(
        data: (employee) {
          return Column(
            children: [
              Text(employee!.fullName),
              Text(employee.email),
              Text(employee.contactNumber),
            ]
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}