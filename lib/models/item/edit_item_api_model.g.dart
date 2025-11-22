// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditItemApiModel _$EditItemApiModelFromJson(Map<String, dynamic> json) =>
    EditItemApiModel(
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      supplierId: (json['supplierId'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$EditItemApiModelToJson(EditItemApiModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'category': instance.category,
      'location': instance.location,
      'supplierId': instance.supplierId,
      'isActive': instance.isActive,
    };
