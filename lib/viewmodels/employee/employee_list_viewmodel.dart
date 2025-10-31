import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/employee_repository_impl.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';

final employeeListViewModelProvider = AsyncNotifierProvider<EmployeeListViewModel, List<Employee?>>(
  EmployeeListViewModel.new,
);

class EmployeeListViewModel extends AsyncNotifier<List<Employee?>> {
  @override
  Future<List<Employee?>> build() async {
    final employeeRepository = ref.read(employeeRepositoryProvider);
    return employeeRepository.getEmployeeList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(employeeRepositoryProvider).getEmployeeList());
  }
}