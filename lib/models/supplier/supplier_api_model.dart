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

  SupplierApiModel({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
  });

  factory SupplierApiModel.fromJson(Map<String, dynamic> json) => _$SupplierApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierApiModelToJson(this);

  Supplier toSupplier() {
    return Supplier(
        id: id,
        companyName: companyName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber
    );
  }
}