import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/viewmodels/item/item_detail_viewmodel.dart';

class ItemDetailScreen extends ConsumerWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDetailAsyncValue =
    ref.watch(itemDetailViewModelProvider(item.id));

    return itemDetailAsyncValue.when(
      data: (item) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: GoRouter.of(context).pop,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            // Example action: Edit button
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(
                  'itemEdit',
                  queryParameters: {
                    'actionType': 'edit'
                  },
                  pathParameters: {
                    'id': item!.id.toString()
                  },
                  extra: item
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, item!),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Inventory Details'),
              _buildInventoryCard(context, item),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Supplier Information'),
              _buildSupplierCard(context, item),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Location & Category'),
              _buildLocationCard(context, item),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: FilledButton(onPressed: () {}, child: Text('Stock In'))),
                  const SizedBox(width: 8),
                  Expanded(child: FilledButton(onPressed: () {}, child: Text('Stock Out')))
                ],
              )
            ],
          ),
        ),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Text('Error: $err'),
          ),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Item item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.itemName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: item.isActive ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  item.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: item.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            item.itemName.substring(0, 1).toUpperCase(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInventoryCard(BuildContext context, Item item) {
    final isLowStock = item.currentStockLevel <= item.reorderLevel;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    context,
                    'Current Stock',
                    item.currentStockLevel.toString(),
                    isLarge: true,
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    context,
                    'Target Level',
                    item.targetStockLevel.toString(),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    context,
                    'Reorder Level',
                    item.reorderLevel.toString(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Capacity',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: item.targetStockLevel > 0
                            ? (item.currentStockLevel / item.targetStockLevel)
                            .clamp(0.0, 1.0)
                            : 0,
                        backgroundColor: Colors.grey[200],
                        color: isLowStock ? Theme.of(context).colorScheme.error : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, Item item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: const Icon(Icons.storefront),
        title: Text(item.supplier.companyName),
        subtitle: Text(item.supplier.contactPerson),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          throw UnimplementedError();
        },
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, Item item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(
              context,
              'Category',
              item.category,
              icon: Icons.category_outlined,
            ),
            const Divider(height: 24),
            _buildDetailRow(
              context,
              'Location / Shelf',
              item.location,
              icon: Icons.location_on_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor, bool isLarge = false, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: isLarge
                    ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                )
                    : Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
