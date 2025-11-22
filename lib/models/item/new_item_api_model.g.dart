// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewItemApiModel _$NewItemApiModelFromJson(Map<String, dynamic> json) =>
    NewItemApiModel(
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      supplierId: (json['supplierId'] as num).toInt(),
      reorderLevel: (json['reorderLevel'] as num).toInt(),
      targetStockLevel: (json['targetStockLevel'] as num).toInt(),
      currentStockLevel: (json['currentStockLevel'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$NewItemApiModelToJson(NewItemApiModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'category': instance.category,
      'location': instance.location,
      'supplierId': instance.supplierId,
      'reorderLevel': instance.reorderLevel,
      'targetStockLevel': instance.targetStockLevel,
      'currentStockLevel': instance.currentStockLevel,
      'isActive': instance.isActive,
    };
