import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/repositories/implementation/item_repository_impl.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/repositories/item_repository.dart';

final itemListViewModelProvider = AsyncNotifierProvider<ItemListViewModel, List<Item?>>(
  ItemListViewModel.new,
);

class ItemListViewModel extends AsyncNotifier<List<Item?>> {
  late final ItemRepository _repository;

  @override
  Future<List<Item?>> build() async {
    _repository = ref.watch(itemRepositoryProvider);
    return _repository.getItemList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getItemList());
  }
}