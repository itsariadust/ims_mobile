import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/errors/failures.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/supplier/new_supplier.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/repositories/implementation/supplier_repository_impl.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_detail_viewmodel.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_list_viewmodel.dart';

final supplierFormViewModelProvider = Provider<SupplierFormViewModel>((ref) {
  return SupplierFormViewModel(ref);
});


class SupplierFormViewModel {
  final Ref _ref;

  SupplierFormViewModel(this._ref);

  Future<Result> addSupplier(NewSupplier supplier) async {
    final repository = _ref.read(supplierRepositoryProvider);

    try {
      final newSupplier = await repository.addSupplier(supplier);

      _ref.invalidate(supplierListViewModelProvider);
      return Success(newSupplier);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
  
  Future<Result> updateSupplier(Supplier supplier) async {
    final repository = _ref.read(supplierRepositoryProvider);

    try {
      final updatedSupplier = await repository.updateSupplier(supplier);

      _ref.invalidate(supplierListViewModelProvider);
      _ref.invalidate(supplierDetailViewModelProvider);
      return Success(updatedSupplier);
    } catch (e) {
      rethrow;
    }
  }
}