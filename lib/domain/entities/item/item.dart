import 'package:flutter/cupertino.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';

@immutable
class Item {
  final int id;
  final String itemName;
  final String category;
  final String location;
  final Supplier supplier;
  final int reorderLevel;
  final int targetStockLevel;
  final int currentStockLevel;
  final bool isActive;

  const Item({
    required this.id,
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplier,
    required this.reorderLevel,
    required this.targetStockLevel,
    required this.currentStockLevel,
    required this.isActive,
  });
}