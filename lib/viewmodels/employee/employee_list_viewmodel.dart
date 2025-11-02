import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/employee_repository_impl.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';

final employeeListViewModelProvider = StreamProvider<List<Employee?>>((ref) {
  final employeeRepository = ref.watch(employeeRepositoryProvider);
  return employeeRepository.getEmployeeList();
});