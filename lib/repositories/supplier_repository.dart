import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/supplier/new_supplier.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getSupplierList();
  Future<Supplier> getSupplier(int id);
  Future<Supplier> addSupplier(NewSupplier supplier);
  Future<Supplier> updateSupplier(Supplier supplier);
  Future<Result> deactivateSupplier(int id);
  Future<Result> reactivateSupplier(int id);
  Future<List<Supplier>> searchSuppliers(String query);
}