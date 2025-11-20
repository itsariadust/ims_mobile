import 'package:flutter/cupertino.dart';

@immutable
class SupplierSimple {
  final int id;
  final String companyName;

  const SupplierSimple({
    required this.id,
    required this.companyName,
  });

  SupplierSimple copyWith({
    int? id,
    String? companyName,
  }) {
    return SupplierSimple(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
    );
  }
}