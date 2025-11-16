// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_supplier_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewSupplierApiModel _$NewSupplierApiModelFromJson(Map<String, dynamic> json) =>
    NewSupplierApiModel(
      companyName: json['companyName'] as String,
      contactPerson: json['contactPerson'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$NewSupplierApiModelToJson(
  NewSupplierApiModel instance,
) => <String, dynamic>{
  'companyName': instance.companyName,
  'contactPerson': instance.contactPerson,
  'email': instance.email,
  'contactNumber': instance.contactNumber,
  'isActive': instance.isActive,
};
