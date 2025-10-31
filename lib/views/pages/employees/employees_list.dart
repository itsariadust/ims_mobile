import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/viewmodels/employee/employee_list_viewmodel.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeListAsyncValue = ref.watch(employeeListViewModelProvider);
    return Scaffold(
      body: employeeListAsyncValue.when(
        data: (employees) {
          return RefreshIndicator(
            onRefresh: () async {
              return await ref.refresh(employeeListViewModelProvider.future);
            },
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  onTap: () {
                    context.pushNamed('employeeDetail', pathParameters: {
                      'id': employee.id.toString()
                    });
                  },
                  key: ValueKey(employee!.id),
                  leading: CircleAvatar(
                    child: Text(employee.fullName[0]),
                  ),
                  title: Text(employee.fullName),
                  subtitle: Text(employee.email),
                  trailing: Icon(Icons.arrow_right),
                );
              }
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}