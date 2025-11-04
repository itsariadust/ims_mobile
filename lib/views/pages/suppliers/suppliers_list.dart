import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/routes/app_router.dart'; // to be used later
import 'package:ims_mobile/viewmodels/supplier/supplier_list_viewmodel.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierListAsyncValue = ref.watch(supplierListViewModelProvider);
    // final rootContext = ref.read(appRouterProvider).routerDelegate.navigatorKey.currentContext;
    return Scaffold(
      body: supplierListAsyncValue.when(
        data: (suppliers) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(supplierListViewModelProvider);
              return await ref.read(supplierListViewModelProvider.future);
            },
            child: ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return ListTile(
                  onTap: () {

                  },
                  key: ValueKey(supplier!.id),
                  leading: CircleAvatar(
                    child: Text(supplier.companyName[0]),
                  ),
                  title: Text(supplier.companyName),
                  subtitle: Text(supplier.contactPerson),
                  trailing: Icon(Icons.arrow_right)
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