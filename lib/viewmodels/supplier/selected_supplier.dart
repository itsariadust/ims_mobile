import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';

class SelectedSupplierNotifier extends Notifier<Supplier?> {
  @override
  Supplier? build() {
    return null;
  }

  void selectSupplier(Supplier supplier) {
    state = supplier;
  }

  void clearSelection() {
    state = null;
  }
}

final selectedSupplierProvider = NotifierProvider<SelectedSupplierNotifier, Supplier?>(
  SelectedSupplierNotifier.new,
);