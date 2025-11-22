import 'package:flutter/cupertino.dart';

@immutable
class NewItem {
  final String itemName;
  final String category;
  final String location;
  final int supplierId;
  final int reorderLevel;
  final int targetStockLevel;
  final int currentStockLevel;
  final bool isActive;

  const NewItem({
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplierId,
    required this.reorderLevel,
    required this.targetStockLevel,
    required this.currentStockLevel,
    required this.isActive,
  });
}