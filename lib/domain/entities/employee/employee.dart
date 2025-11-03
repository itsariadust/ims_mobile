import 'package:ims_mobile/models/employee/employee_api_model.dart';

class Employee {
  final int id;
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String role;

  Employee({
    required this.id,
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.role,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.toEmployee(EmployeeApiModel apiModel) {
    return Employee(
      id: apiModel.id,
      uuid: apiModel.uuid,
      firstName: apiModel.firstName,
      lastName: apiModel.lastName,
      email: apiModel.email,
      contactNumber: apiModel.contactNumber,
      role: apiModel.role,
    );
  }
}