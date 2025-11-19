// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeApiModel _$EmployeeApiModelFromJson(Map<String, dynamic> json) =>
    EmployeeApiModel(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$EmployeeApiModelToJson(EmployeeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'contactNumber': instance.contactNumber,
      'role': instance.role,
      'isActive': instance.isActive,
    };
