import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/supplier/new_supplier.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/models/supplier/new_supplier_api_model.dart';
import 'package:ims_mobile/models/supplier/supplier_api_model.dart';
import 'package:ims_mobile/repositories/supplier_repository.dart';
import 'package:ims_mobile/services/supplier_service.dart';

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return SupplierRepositoryImpl(ref.watch(supplierServiceProvider));
});


class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierService _supplierService;

  SupplierRepositoryImpl(this._supplierService);

  @override
  Future<List<Supplier>> getSupplierList() async {
    try {
      final supplierList = await _supplierService.fetchAllSuppliers();

      return supplierList.map((supplier) => supplier.toSupplier()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Supplier> getSupplier(int id) async {
    try {
      final supplier = await _supplierService.fetchSupplier(id);
      return supplier.toSupplier();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Supplier> addSupplier(NewSupplier supplier) async {
    final newSupplierModel = NewSupplierApiModel.fromDomain(supplier);
    final newSupplier =  await _supplierService.addSupplier(newSupplierModel);
    return newSupplier.toSupplier();
  }

  @override
  Future<Supplier> updateSupplier(Supplier supplier) async {
    final supplierModel = SupplierApiModel.fromDomain(supplier);
    final updatedSupplier = await _supplierService.updateSupplier(supplier.id, supplierModel);
    return updatedSupplier.toSupplier();
  }
}