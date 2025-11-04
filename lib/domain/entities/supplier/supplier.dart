import 'package:ims_mobile/models/supplier/supplier_api_model.dart';

class Supplier {
  final int id;
  final String companyName;
  final String contactPerson;
  final String email;
  final String contactNumber;

  Supplier({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
  });

  factory Supplier.toSupplier(SupplierApiModel apiModel) {
    return Supplier(
      id: apiModel.id,
      companyName: apiModel.companyName,
      contactPerson: apiModel.contactPerson,
      email: apiModel.email,
      contactNumber: apiModel.contactNumber,
    );
  }
}