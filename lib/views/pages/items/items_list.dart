import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/routes/app_router.dart';
import 'package:ims_mobile/viewmodels/item/item_list_viewmodel.dart';

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemListAsyncValue = ref.watch(itemListViewModelProvider);
    final rootContext = ref.read(appRouterProvider).routerDelegate.navigatorKey.currentContext;
    return Scaffold(
      body: itemListAsyncValue.when(
        data: (items) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(itemListViewModelProvider);
              return await ref.read(itemListViewModelProvider.future);
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                      'itemDetails',
                      pathParameters: {
                        'id': item.id.toString()
                      },
                      extra: item
                    );
                  },
                  key: ValueKey(item!.id),
                  leading: CircleAvatar(
                    child: Text(item.itemName[0]),
                  ),
                  title: Text(item.itemName),
                  subtitle: Text(item.category),
                  trailing: Text(item.currentStockLevel.toString())
                );
              },
            )
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}