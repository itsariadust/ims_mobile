import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
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
}