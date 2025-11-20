import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/views/pages/employees/employee_form.dart';
import 'package:ims_mobile/views/pages/employees/employees_list.dart';
import 'package:ims_mobile/views/pages/home.dart';
import 'package:ims_mobile/views/pages/items/item_detail.dart';
import 'package:ims_mobile/views/pages/items/items_list.dart';
import 'package:ims_mobile/views/pages/login.dart';
import 'package:ims_mobile/views/pages/main_screen.dart';
import 'package:ims_mobile/views/pages/splash.dart';
import 'package:ims_mobile/views/pages/suppliers/supplier_form.dart';
import 'package:ims_mobile/views/pages/suppliers/suppliers_list.dart';
import 'package:ims_mobile/views/pages/transactions.dart';
import 'package:ims_mobile/core/routes/transitions.dart';

final rootNavigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = ref.read(rootNavigatorKeyProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash', builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // The UI shell (`MainScreen`) is built here
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch for the Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => buildFadeThroughTransition(
                  context: context,
                  state: state,
                  child: const HomeScreen(),
                )
              ),
            ],
          ),
          // Branch for the Inventory tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                pageBuilder: (context, state) => buildFadeThroughTransition(
                  context: context,
                  state: state,
                  child: const ItemsScreen(),
                )
              ),
            ],
          ),
          // Branch for the Suppliers tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/suppliers',
                pageBuilder: (context, state) => buildFadeThroughTransition(
                  context: context,
                  state: state,
                  child: const SuppliersScreen(),
                )
              ),
            ],
          ),
          // Branch for the Transactions tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                pageBuilder: (context, state) => buildFadeThroughTransition(
                  context: context,
                  state: state,
                  child: const TransactionsScreen(),
                )
              ),
            ],
          ),
          // Branch for the Employees tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/employees',
                pageBuilder: (context, state) => buildFadeThroughTransition(
                  context: context,
                  state: state,
                  child: const EmployeesScreen(),
                )
              ),
            ],
          ),
        ],
      ),
      // Add/Edit Employee
      GoRoute(
        name: 'employeeAdd',
        path: '/employee/add',
        builder: (BuildContext context, GoRouterState state) {
          final String? actionType = state.uri.queryParameters['actionType'];
          final Employee? employeeObject = state.extra as Employee?;
          return EmployeeForm(
            actionType: actionType,
            employee: employeeObject,
          );
        },
      ),
      GoRoute(
        name: 'employeeEdit',
        path: '/employee/:id',
        builder: (BuildContext context, GoRouterState state) {
          final String? actionType = state.uri.queryParameters['actionType'];
          final Employee employeeObject = state.extra as Employee;
          return EmployeeForm(
            actionType: actionType,
            employee: employeeObject, // Full data for editing
          );
        },
      ),
      // Add/Edit Supplier
      GoRoute(
        name: 'supplierAdd',
        path: '/supplier/add',
        builder: (BuildContext context, GoRouterState state) {
          final String? actionType = state.uri.queryParameters['actionType'];
          final Supplier? supplierObject = state.extra as Supplier?;
          return SupplierForm(
            actionType: actionType,
            supplier: supplierObject,
          );
        },
      ),
      GoRoute(
        name: 'supplierEdit',
        path: '/supplier/:id',
        builder: (BuildContext context, GoRouterState state) {
          final String? actionType = state.uri.queryParameters['actionType'];
          final Supplier supplierObject = state.extra as Supplier;
          return SupplierForm(
            actionType: actionType,
            supplier: supplierObject, // Full data for editing
          );
        },
      ),
      // Item Details
      GoRoute(
        name: 'itemDetails',
        path: '/items/:id',
        builder: (BuildContext context, GoRouterState state) {
          final Item itemObject = state.extra as Item;
          return ItemDetailScreen(
            item: itemObject, // Full data for editing
          );
        },
      ),
    ],
  );
});