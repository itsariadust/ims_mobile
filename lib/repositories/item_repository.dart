import 'package:ims_mobile/domain/entities/item/edit_item.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/domain/entities/item/new_item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItemList();
  Future<Item> getItem(int id);
  Future<Item> addItem(NewItem item);
  Future<Item> editItem(EditItem updatedItemData, int id);
}