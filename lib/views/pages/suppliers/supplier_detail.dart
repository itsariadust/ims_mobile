import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_detail_viewmodel.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_list_viewmodel.dart';

class SupplierDetailScreen extends ConsumerWidget {
  final int supplierId;
  const SupplierDetailScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierDetailAsyncValue = ref.watch(supplierDetailViewModelProvider(supplierId));

    return supplierDetailAsyncValue.when(
      data: (supplier) {
        if (supplier == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text('Supplier not found.'),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.person, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    supplier.companyName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Contact Person'),
                  subtitle: Text(supplier.contactPerson),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(supplier.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () { /* TODO: Implement email action */ },
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Contact Number'),
                  subtitle: Text(supplier.contactNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () { /* TODO: Implement call action */ },
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.circle),
                  title: const Text('Status'),
                  subtitle: Text(supplier.isActive.toString()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Edit button
            FilledButton.icon(
              onPressed: () {
                context.pushNamed(
                  'supplierEdit',
                  queryParameters: {
                    'actionType': 'edit'
                  },
                  pathParameters: {
                    'id': supplier.id.toString()
                  },
                  extra: supplier
                );
                context.pop();
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Supplier'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            () {
              final bool isActive = supplier.isActive;
              final String label = isActive ? 'Deactivate Supplier' : 'Activate Supplier';
              final IconData icon = isActive ? Icons.close : Icons.check;
              final Color buttonColor = isActive ? Theme.of(context).colorScheme.error : Colors.green;
              final String dialogTitle = isActive ? 'Deactivate supplier?' : 'Activate supplier?';
              final String dialogContent = isActive ? 'Are you sure you want to deactivate this supplier?' : 'Are you sure you want to activate this supplier?';

              return FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(dialogTitle),
                      content: Text(dialogContent),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _onStatusChange(context, supplier, ref);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(icon),
                label: Text(label),
                style: FilledButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }(),
            const SizedBox(height: 8),
          ]
        );
      },
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text('Error: $err'),
        ),
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _onStatusChange(BuildContext context, Supplier supplier, WidgetRef ref) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    final notifier = ref.read(supplierDetailViewModelProvider(supplier.id).notifier);

    Result<dynamic> result;

    if (supplier.isActive == true) {
      result = await notifier.deactivate(supplier.id);
    } else {
      result = await notifier.reactivate(supplier.id);
    }

    if (!context.mounted) return;

    GoRouter.of(context).pop();

    switch (result) {
      case Success():
        GoRouter.of(context)..pop()..pop();
        ref.refresh(supplierListViewModelProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Supplier status changed successfully'))
        );
        break;
      case FailureResult():
        GoRouter.of(context)..pop()..pop();
        ref.refresh(supplierListViewModelProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to change supplier status'))
        );
        break;
    }
  }
}