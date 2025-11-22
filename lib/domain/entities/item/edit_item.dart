import 'package:flutter/cupertino.dart';

@immutable
class EditItem {
  final String itemName;
  final String category;
  final String location;
  final int supplierId;
  final bool isActive;

  const EditItem({
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplierId,
    required this.isActive,
  });
}