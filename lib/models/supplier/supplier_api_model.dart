import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplier_api_model.g.dart';
@JsonSerializable()
class SupplierApiModel {
  final int id;
  final String companyName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final bool isActive;

  SupplierApiModel({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
    required this.isActive
  });

  factory SupplierApiModel.fromJson(Map<String, dynamic> json) => _$SupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierApiModelToJson(this);

  factory SupplierApiModel.fromDomain(Supplier supplier) {
    return SupplierApiModel(
      id: supplier.id,
      companyName: supplier.companyName,
      contactPerson: supplier.contactPerson,
      email: supplier.email,
      contactNumber: supplier.contactNumber,
      isActive: supplier.isActive,
    );
  }

  Supplier toSupplier() {
    return Supplier(
        id: id,
        companyName: companyName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        isActive: isActive,
    );
  }
}