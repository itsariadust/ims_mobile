import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FloatingActionMenu extends ConsumerWidget {
  const FloatingActionMenu({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpandableFab(
      distance: 72,
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      children: _getFabOptions(context, currentIndex),
    );
  }

  List<Widget> _getFabOptions(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0:
        return [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Stock In'),
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Stock Out'),
            icon: const Icon(Icons.remove),
            onPressed: () {},
          ),
        ];
      case 1: // Inventory Page
        return [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('New Item'),
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ];
      case 2: // Suppliers
        return [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('New Supplier'),
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).pushNamed('supplierAdd', queryParameters: {'actionType': 'add'});
            },
          ),
        ];
      case 3: // Transactions Page
        return [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Stock In'),
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Stock Out'),
            icon: const Icon(Icons.remove),
            onPressed: () {},
          ),
        ];
      case 4:
        return [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text('Add Employee'),
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).pushNamed('employeeAdd', queryParameters: {'actionType': 'add'});
            },
          ),
        ];
      default:
      // Return an empty list for pages with no FAB options
        return [];
    }
  }
}