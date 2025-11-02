import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/core/functions/add_employee.dart';
import 'package:ims_mobile/viewmodels/employee/employee_list_viewmodel.dart';

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
  final _passwordController = TextEditingController();
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
    _passwordController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final employee = widget.employee;
    if (employee == null) {
      setState(() {
        _isFormModified = _firstNameController.text.isNotEmpty ||
            _lastNameController.text.isNotEmpty ||
            _emailController.text.isNotEmpty ||
            _contactNumberController.text.isNotEmpty ||
            _passwordController.text.isNotEmpty;
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

  Future<void> _onSave() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try {
      if (widget.actionType == 'add') {
        createUser(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _contactNumberController.text,
          _passwordController.text,
          _selectedRole!
        );
        ref.invalidate(employeeListViewModelProvider);
        if (mounted) {
          GoRouter.of(context)..pop()..pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee added successfully.'))
          );
        }
      }
      if (widget.actionType == 'edit') {
        // TODO: edit employee function call
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['ADMIN', 'MANAGER', 'WORKER'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_isFormModified) {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Discard changes?'),
                  content: const Text('Are you sure you want to discard your changes?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: Text('No')
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context)..pop()..pop();
                      },
                      child: Text('Yes')
                    )
                  ],
                );
              });
            } else {
              GoRouter.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back)
        ),
        title: _setTitle(),
        actions: [
          TextButton(onPressed: _isFormModified ? _onSave : null, child: const Text('SAVE'))
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
              if (widget.actionType == 'add')
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  )
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