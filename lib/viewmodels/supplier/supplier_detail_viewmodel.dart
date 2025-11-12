import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}