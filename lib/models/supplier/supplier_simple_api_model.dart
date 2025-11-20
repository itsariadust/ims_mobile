import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier_simple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_simple_api_model.g.dart';
@JsonSerializable()
class SupplierSimpleApiModel {
  final int id;
  final String companyName;

  SupplierSimpleApiModel({
    required this.id,
    required this.companyName,
  });

  factory SupplierSimpleApiModel.fromJson(Map<String, dynamic> json) => _$SupplierSimpleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierSimpleApiModelToJson(this);

  factory SupplierSimpleApiModel.fromDomain(SupplierSimple supplier) {
    return SupplierSimpleApiModel(
      id: supplier.id,
      companyName: supplier.companyName,
    );
  }

  SupplierSimple toDomain() {
    return SupplierSimple(
      id: id,
      companyName: companyName,
    );
  }
}