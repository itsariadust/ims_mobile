import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/repositories/employee_repository.dart';
import 'package:ims_mobile/services/employee_service.dart';

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(ref.watch(employeeServiceProvider));
});

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeService _employeeService;

  EmployeeRepositoryImpl(this._employeeService);

  @override
  Stream<List<Employee>> getEmployeeList() {
    try {
      final employeeListStream = _employeeService.getEmployeeStream();

      return employeeListStream.map((employee) {
        return employee.map((e) => e.toEmployee()).toList();
      });
    } catch (e) {
      return Stream.error(e);
    }
  }

  @override
  Future<Employee> getEmployee(int id) async {
    try {
      final employee = await _employeeService.fetchEmployee(id);

      return employee.toEmployee();
    } catch (e) {
      rethrow;
    }
  }
}