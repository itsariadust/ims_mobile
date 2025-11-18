import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/repositories/implementation/supplier_repository_impl.dart';

final supplierDetailViewModelProvider = AsyncNotifierProvider.autoDispose.family<SupplierDetailViewModel, Supplier?, int>(
  SupplierDetailViewModel.new
);

class SupplierDetailViewModel extends AsyncNotifier<Supplier?> {
  final int id;
  SupplierDetailViewModel(this.id);

  @override
  Future<Supplier?> build() async {
    final supplierRepository = ref.read(supplierRepositoryProvider);
    final supplier = supplierRepository.getSupplier(id);
    return supplier;
  }

  Future<Result> deactivate(int id) async {
    final supplierRepository = ref.read(supplierRepositoryProvider);
    final result = supplierRepository.deactivateSupplier(id);
    return result;
  }

  Future<Result> reactivate(int id) async {
    final supplierRepository = ref.read(supplierRepositoryProvider);
    final result = supplierRepository.reactivateSupplier(id);
    return result;
  }
}