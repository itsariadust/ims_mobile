import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/item/edit_item.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/domain/entities/item/new_item.dart';
import 'package:ims_mobile/models/item/new_item_api_model.dart';
import 'package:ims_mobile/models/item/edit_item_api_model.dart';
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
      final itemList = _itemService.fetchAllItems();
      return itemList.then((items) => items.map((item) => item.toDomain()).toList());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Item> getItem(int id) {
    try {
      final item = _itemService.fetchItem(id);
      return item.then((item) => item.toDomain());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Item> addItem(NewItem item) async {
    try {
      final newItemModel = NewItemApiModel.fromDomain(item);
      final newItem = await _itemService.addItem(newItemModel);
      return newItem.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Item> editItem(EditItem updatedItemData, int id) async {
    try {
      final editedItemModel = EditItemApiModel.fromDomain(updatedItemData);
      final editedItem = await _itemService.editItem(editedItemModel, id);
      return editedItem.toDomain();
    } catch (e) {
      rethrow;
    }
  }
}