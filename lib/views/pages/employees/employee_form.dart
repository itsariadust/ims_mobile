import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';

class EmployeeForm extends ConsumerStatefulWidget {
  const EmployeeForm({super.key, this.employee, this.actionType});

  final Employee? employee;
  final String? actionType;

  @override
  ConsumerState<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends ConsumerState<EmployeeForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  String? _selectedRole;

  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    if (employee != null) {
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _emailController.text = employee.email;
      _contactNumberController.text = employee.contactNumber ?? '';
      _selectedRole = employee.role;
    }

    _firstNameController.addListener(_checkForChanges);
    _lastNameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _contactNumberController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final employee = widget.employee;
    if (employee == null) {
      setState(() {
        _isFormModified = _firstNameController.text.isNotEmpty ||
            _lastNameController.text.isNotEmpty ||
            _emailController.text.isNotEmpty ||
            _contactNumberController.text.isNotEmpty;
      });
      return;
    }

    final hasChanged = _firstNameController.text != employee.firstName ||
        _lastNameController.text != employee.lastName ||
        _emailController.text != employee.email ||
        _contactNumberController.text != (employee.contactNumber ?? '') ||
        _selectedRole != employee.role;

    setState(() {
      _isFormModified = hasChanged;
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<String> options = ['ADMIN', 'MANAGER', 'WORKER'];

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
              ),
              const SizedBox(height: 32),
              DropdownMenu<String>(
                initialSelection: _selectedRole,
                onSelected: (String? value) {
                  setState(() {
                    _selectedRole = value;
                  });
                  _checkForChanges();
                },
                dropdownMenuEntries: options.map<DropdownMenuEntry<String>>(
                        (String value) => DropdownMenuEntry<String>(value: value, label: value)
                ).toList(),
                label: const Text('Role'),
                expandedInsets: EdgeInsets.zero,
              )
            ]
          ),
        )
      )
    );
  }

  Widget? _setTitle() {
    if (widget.actionType == 'add') {
      return const Text('Add Employee');
    } else {
      return const Text('Edit Employee');
    }
  }
}