

import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/models/supplier/supplier_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_api_model.g.dart';
@JsonSerializable()
class ItemApiModel {
  final int id;
  final String itemName;
  final String category;
  final String location;
  final SupplierApiModel supplier;
  final int reorderLevel;
  final int targetStockLevel;
  final int currentStockLevel;
  final bool isActive;

  ItemApiModel({
    required this.id,
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplier,
    required this.reorderLevel,
    required this.targetStockLevel,
    required this.currentStockLevel,
    required this.isActive
  });

  factory ItemApiModel.fromJson(Map<String, dynamic> json) => _$ItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemApiModelToJson(this);

  Item toDomain() {
    return Item(
      id: id,
      itemName: itemName,
      category: category,
      location: location,
      supplier: supplier.toDomain(),
      reorderLevel: reorderLevel,
      targetStockLevel: targetStockLevel,
      currentStockLevel: currentStockLevel,
      isActive: isActive,
    );
  }

  factory ItemApiModel.fromDomain(Item item) {
    return ItemApiModel(
      id: item.id,
      itemName: item.itemName,
      category: item.category,
      location: item.location,
      supplier: item.supplier.toApiModel(),
      reorderLevel: item.reorderLevel,
      targetStockLevel: item.targetStockLevel,
      currentStockLevel: item.currentStockLevel,
      isActive: item.isActive
    );
  }
}