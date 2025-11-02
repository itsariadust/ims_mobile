import 'package:ims_mobile/domain/entities/employee/employee.dart';

abstract class EmployeeRepository {
  Stream<List<Employee>> getEmployeeList();
  Future<Employee> getEmployee(int id);
}