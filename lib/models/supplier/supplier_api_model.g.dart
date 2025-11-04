// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierApiModel _$SupplierApiModelFromJson(Map<String, dynamic> json) =>
    SupplierApiModel(
      id: (json['id'] as num).toInt(),
      companyName: json['companyName'] as String,
      contactPerson: json['contactPerson'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
    );

Map<String, dynamic> _$SupplierApiModelToJson(SupplierApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'contactPerson': instance.contactPerson,
      'email': instance.email,
      'contactNumber': instance.contactNumber,
    };
