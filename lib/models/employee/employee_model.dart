import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';
@JsonSerializable()
class Employee {
  final int id;
  final String keycloakUuid;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String role;

  Employee({
    required this.id,
    required this.keycloakUuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.role
  });

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}