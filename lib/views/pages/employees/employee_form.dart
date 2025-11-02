import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';

class EmployeeForm extends ConsumerWidget {
  const EmployeeForm({super.key, this.employee, this.actionType});

  final Employee? employee;
  final String? actionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSaveButtonEnabled = false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)
        ),
        title: _setTitle(),
        actions: [
          TextButton(
            onPressed: isSaveButtonEnabled ? () {} : null,
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
                initialValue: employee?.firstName,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                initialValue: employee?.lastName,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                initialValue: employee?.email,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
                initialValue: employee?.contactNumber,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Role',
                ),
                initialValue: employee?.role,
              ),
            ]
          ),
        )
      )
    );
  }

  Widget? _setTitle() {
    if (actionType == 'add') {
      return Text('Add Employee');
    } else {
      return Text('Edit Employee');
    }
  }
}