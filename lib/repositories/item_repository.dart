import 'package:ims_mobile/domain/entities/item/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItemList();
}