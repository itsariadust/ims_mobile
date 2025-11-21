import 'package:flutter/cupertino.dart';
import 'package:ims_mobile/models/supplier/supplier_api_model.dart';

@immutable
class Supplier {
  final int id;
  final String companyName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final bool isActive;

  const Supplier({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
    required this.isActive,
  });

  Supplier copyWith({
    int? id,
    String? companyName,
    String? contactPerson,
    String? email,
    String? contactNumber,
    bool? isActive
  }) {
    return Supplier(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      isActive: isActive ?? this.isActive,
    );
  }

  SupplierApiModel toApiModel() {
    return SupplierApiModel(
      id: id,
      companyName: companyName,
      contactPerson: contactPerson,
      email: email,
      contactNumber: contactNumber,
      isActive: isActive
    );
  }
}