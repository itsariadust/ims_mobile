import 'package:ims_mobile/domain/entities/supplier/new_supplier.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_supplier_api_model.g.dart';
@JsonSerializable()
class NewSupplierApiModel {
  final String companyName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final bool isActive;

  NewSupplierApiModel({
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
    required this.isActive,
  });

  factory NewSupplierApiModel.fromJson(Map<String, dynamic> json) => _$NewSupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewSupplierApiModelToJson(this);

  factory NewSupplierApiModel.fromDomain(NewSupplier supplier) {
    return NewSupplierApiModel(
        companyName: supplier.companyName,
        contactPerson: supplier.contactPerson,
        email: supplier.email,
        contactNumber: supplier.contactNumber,
        isActive: supplier.isActive,
    );
  }

  NewSupplier toSupplier() {
    return NewSupplier(
        companyName: companyName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        isActive: isActive,
    );
  }
}