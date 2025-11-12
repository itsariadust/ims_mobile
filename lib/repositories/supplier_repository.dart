import 'package:ims_mobile/domain/entities/supplier/supplier.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getSupplierList();
  Future<Supplier> getSupplier(int id);
}