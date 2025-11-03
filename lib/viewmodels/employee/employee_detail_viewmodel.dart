import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/repositories/implementation/employee_repository_impl.dart';

final employeeDetailViewModelProvider = AsyncNotifierProvider.autoDispose.family<EmployeeDetailViewModel, Employee?, int>(
  EmployeeDetailViewModel.new,
);

class EmployeeDetailViewModel extends AsyncNotifier<Employee?> {
  final int id;
  EmployeeDetailViewModel(this.id);

  @override
  Future<Employee?> build() async {
    final employeeRepository = ref.read(employeeRepositoryProvider);
    final employee = await employeeRepository.getEmployee(id);
    return employee;
  }
}