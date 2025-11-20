import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/repositories/item_repository.dart';
import 'package:ims_mobile/services/item_service.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepositoryImpl(ref.watch(itemServiceProvider));
});


class ItemRepositoryImpl implements ItemRepository {
  final ItemService _itemService;

  ItemRepositoryImpl(this._itemService);

  @override
  Future<List<Item>> getItemList() {
    try {
      final itemService = _itemService.fetchAllItems();
      return itemService.then((items) => items.map((item) => item.toDomain()).toList());
    } catch (e) {
      rethrow;
    }
  }
}