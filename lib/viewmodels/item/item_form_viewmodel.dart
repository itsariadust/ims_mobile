import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/errors/failures.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/item/edit_item.dart';
import 'package:ims_mobile/domain/entities/item/new_item.dart';
import 'package:ims_mobile/repositories/implementation/item_repository_impl.dart';

final itemFormViewModelProvider = Provider<ItemFormViewModel>((ref) {
  return ItemFormViewModel(ref);
});

class ItemFormViewModel {
  final Ref _ref;

  ItemFormViewModel(this._ref);

  Future<Result> addItem(NewItem item) async {
    final repository = _ref.read(itemRepositoryProvider);

    try {
      final newItem = repository.addItem(item);
      return Success(newItem);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  Future<Result> editItem(EditItem updatedItemData, int id) async {
    final repository = _ref.read(itemRepositoryProvider);

    try {
      final updatedItem = await repository.editItem(updatedItemData, id);
      return Success(updatedItem);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}