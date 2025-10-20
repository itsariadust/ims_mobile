import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/views/components/navigation_drawer.dart';
import 'package:ims_mobile/views/pages/home.dart';
import 'package:ims_mobile/views/pages/inventory.dart';
import 'package:ims_mobile/views/pages/suppliers.dart';
import 'package:ims_mobile/views/pages/transactions.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem('Home', Icons.home, HomeScreen()),
    _NavItem('Inventory', Icons.inventory, InventoryScreen()),
    _NavItem('Suppliers', Icons.store, SuppliersScreen()),
    _NavItem('Transactions', Icons.receipt, TransactionsScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _navItems[_selectedIndex].label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person)
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _navItems[_selectedIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final Widget widget;

  const _NavItem(this.label, this.icon, this.widget);
}