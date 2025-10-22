// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  id: (json['id'] as num).toInt(),
  keycloakUuid: json['keycloakUuid'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  contactNumber: json['contactNumber'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'id': instance.id,
  'keycloakUuid': instance.keycloakUuid,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'contactNumber': instance.contactNumber,
  'role': instance.role,
};
