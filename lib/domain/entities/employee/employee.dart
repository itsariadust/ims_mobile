import 'package:ims_mobile/models/employee/employee_api_model.dart';

class Employee {
  final int id;
  final String fullName;
  final String email;
  final String contactNumber;
  final String role;

  Employee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.role
  });

  factory Employee.toEmployee(EmployeeApiModel apiModel) {
    return Employee(
      id: apiModel.id,
      fullName: '${apiModel.firstName} ${apiModel.lastName}',
      email: apiModel.email,
      contactNumber: apiModel.contactNumber,
      role: apiModel.role,
    );
  }
}