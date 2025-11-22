// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemApiModel _$ItemApiModelFromJson(Map<String, dynamic> json) => ItemApiModel(
  id: (json['id'] as num).toInt(),
  itemName: json['itemName'] as String,
  category: json['category'] as String,
  location: json['location'] as String,
  supplier: SupplierApiModel.fromJson(json['supplier'] as Map<String, dynamic>),
  reorderLevel: (json['reorderLevel'] as num).toInt(),
  targetStockLevel: (json['targetStockLevel'] as num).toInt(),
  currentStockLevel: (json['currentStockLevel'] as num).toInt(),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$ItemApiModelToJson(ItemApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemName': instance.itemName,
      'category': instance.category,
      'location': instance.location,
      'supplier': instance.supplier,
      'reorderLevel': instance.reorderLevel,
      'targetStockLevel': instance.targetStockLevel,
      'currentStockLevel': instance.currentStockLevel,
      'isActive': instance.isActive,
    };
