import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/item_repository_impl.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';

final itemListViewModelProvider = AsyncNotifierProvider<ItemListViewModel, List<Item?>>(
  ItemListViewModel.new,
);

class ItemListViewModel extends AsyncNotifier<List<Item?>> {
  @override
  Future<List<Item?>> build() async {
    final itemRepository = ref.read(itemRepositoryProvider);
    return itemRepository.getItemList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(itemRepositoryProvider).getItemList());
  }
}