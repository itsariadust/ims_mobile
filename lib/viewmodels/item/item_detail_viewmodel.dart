import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/repositories/implementation/item_repository_impl.dart';

final itemDetailViewModelProvider = AsyncNotifierProvider.autoDispose.family<ItemDetailViewModel, Item?, int>(
    ItemDetailViewModel.new
);

class ItemDetailViewModel extends AsyncNotifier<Item?> {
  final int id;
  ItemDetailViewModel(this.id);

  @override
  FutureOr<Item?> build() {
    final itemRepository = ref.read(itemRepositoryProvider);
    final item = itemRepository.getItem(id);
    return item;
  }
}