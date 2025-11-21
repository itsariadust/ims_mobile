
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/repositories/implementation/supplier_repository_impl.dart';
import 'package:ims_mobile/repositories/supplier_repository.dart';

final supplierFieldViewModelProvider = AsyncNotifierProvider<SupplierFieldViewModel, List<Supplier?>>(
  SupplierFieldViewModel.new,
);

class SupplierFieldViewModel extends AsyncNotifier<List<Supplier?>> {
  String _currentQuery = '';
  Timer? _timer;
  late final SupplierRepository _repository;

  @override
  FutureOr<List<Supplier?>> build() {
    _repository = ref.watch(supplierRepositoryProvider);
    return [];
  }

  Future<List<Supplier>> searchSuppliers(String query) async {
    _currentQuery = query;
    _timer?.cancel();
    state = const AsyncValue.loading();

    if (query.length < 3) {
      state = const AsyncValue.data([]);
      return [];
    }

    final completer = Completer<List<Supplier>>();
    
    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (_currentQuery != query) return;

      try {
        final results = await _repository.searchSuppliers(query);
        state = AsyncValue.data(results);
        completer.complete(results);
      } catch (e, s) {
        state = AsyncValue.error(e, s);
        completer.completeError(e, s);
      }
    });

    return completer.future;
  }
}