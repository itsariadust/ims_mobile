import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/supplier_repository_impl.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';

final supplierListViewModelProvider = AsyncNotifierProvider<SupplierListViewModel, List<Supplier?>>(
  SupplierListViewModel.new,
);

class SupplierListViewModel extends AsyncNotifier<List<Supplier?>> {
  @override
  Future<List<Supplier?>> build() async {
    final supplierRepository = ref.read(supplierRepositoryProvider);
    return supplierRepository.getSupplierList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(supplierRepositoryProvider).getSupplierList());
  }
}