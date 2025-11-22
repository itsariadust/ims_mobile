import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/item_repository_impl.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';

final itemListViewModelProvider = AsyncNotifierProvider<ItemListViewModel, List<Item?>>(
  ItemListViewModel.new,
);

class ItemListViewModel extends AsyncNotifier<List<Item?>> {
  @override
  Future<List<Item?>> build() async {
    final repository = ref.read(itemRepositoryProvider);
    return repository.getItemList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(itemRepositoryProvider);
    state = await AsyncValue.guard(() => repository.getItemList());
  }
}