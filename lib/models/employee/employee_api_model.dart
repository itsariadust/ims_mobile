import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_api_model.g.dart';
@JsonSerializable()
class EmployeeApiModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String role;

  EmployeeApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.role
  });

  factory EmployeeApiModel.fromJson(Map<String, dynamic> json) => _$EmployeeApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeApiModelToJson(this);

  Employee toEmployee() {
    return Employee(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      contactNumber: contactNumber,
      role: role
    );
  }
}