import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/routes/app_router.dart';
import 'package:ims_mobile/viewmodels/employee/employee_list_viewmodel.dart';
import 'package:ims_mobile/views/pages/employees/employee_detail.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeListAsyncValue = ref.watch(employeeListViewModelProvider);
    final rootContext = ref.read(appRouterProvider).routerDelegate.navigatorKey.currentContext;
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
                    showModalBottomSheet(
                      context: rootContext ?? context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      enableDrag: true,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.6,
                          minChildSize: 0.4,
                          maxChildSize: 1,
                          builder: (context, scrollController) {
                            return EmployeeDetailScreen(
                              employeeId: employee.id,
                            );
                          }
                      );
                      }
                    );
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