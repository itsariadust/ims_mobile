import 'package:flutter/cupertino.dart';

@immutable
class NewSupplier {
  final String companyName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final bool isActive;

  const NewSupplier({
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.contactNumber,
    required this.isActive
  });

  NewSupplier copyWith({
    String? companyName,
    String? contactPerson,
    String? email,
    String? contactNumber,
    bool? isActive
  }) {
    return NewSupplier(
        companyName: companyName ?? this.companyName,
        contactPerson: contactPerson ?? this.contactPerson,
        email: email ?? this.email,
        contactNumber: contactNumber ?? this.contactNumber,
        isActive: isActive ?? this.isActive
    );
  }
}