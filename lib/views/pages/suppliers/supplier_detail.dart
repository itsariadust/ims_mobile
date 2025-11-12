import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_detail_viewmodel.dart';

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
              ],
            ),
            const SizedBox(height: 24),
            // Edit button
            FilledButton.icon(
              onPressed: () {
                
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Supplier'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            // Deactivate button
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Deactivate supplier?'),
                    content: const Text('Are you sure you want to deactivate this supplier?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')
                    ),
                    TextButton(
                        onPressed: () async {
                        },
                        child: Text('Yes')
                      ),
                    ]
                  )
                );
              },
              icon: const Icon(Icons.close),
              label: const Text('Deactivate Supplier'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
}