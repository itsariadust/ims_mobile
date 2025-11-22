import 'package:ims_mobile/domain/entities/item/new_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_item_api_model.g.dart';
@JsonSerializable()
class NewItemApiModel {
  final String itemName;
  final String category;
  final String location;
  final int supplierId;
  final int reorderLevel;
  final int targetStockLevel;
  final int currentStockLevel;
  final bool isActive;

  NewItemApiModel({
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplierId,
    required this.reorderLevel,
    required this.targetStockLevel,
    required this.currentStockLevel,
    required this.isActive
  });

  factory NewItemApiModel.fromJson(Map<String, dynamic> json) => _$NewItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewItemApiModelToJson(this);

  NewItem toDomain() {
    return NewItem(
      itemName: itemName,
      category: category,
      location: location,
      supplierId: supplierId,
      reorderLevel: reorderLevel,
      targetStockLevel: targetStockLevel,
      currentStockLevel: currentStockLevel,
      isActive: isActive,
    );
  }

  factory NewItemApiModel.fromDomain(NewItem item) {
    return NewItemApiModel(
        itemName: item.itemName,
        category: item.category,
        location: item.location,
        supplierId: item.supplierId,
        reorderLevel: item.reorderLevel,
        targetStockLevel: item.targetStockLevel,
        currentStockLevel: item.currentStockLevel,
        isActive: item.isActive
    );
  }
}