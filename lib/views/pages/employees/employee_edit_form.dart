import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';

class EmployeeEditForm extends ConsumerWidget {
  const EmployeeEditForm({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)
        ),
        title: const Text('Edit Employee'),
        actions: [
          TextButton(
            onPressed: () {}, 
            child: Text('SAVE')
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Role',
                ),
              ),
            ]
          ),
        )
      )
    );
  }
}