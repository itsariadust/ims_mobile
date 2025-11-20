// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_simple_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierSimpleApiModel _$SupplierSimpleApiModelFromJson(
  Map<String, dynamic> json,
) => SupplierSimpleApiModel(
  id: (json['id'] as num).toInt(),
  companyName: json['companyName'] as String,
);

Map<String, dynamic> _$SupplierSimpleApiModelToJson(
  SupplierSimpleApiModel instance,
) => <String, dynamic>{'id': instance.id, 'companyName': instance.companyName};
