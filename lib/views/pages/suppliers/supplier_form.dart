import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/supplier/new_supplier.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_form_viewmodel.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_list_viewmodel.dart';

class SupplierForm extends ConsumerStatefulWidget {
  const SupplierForm({super.key, this.supplier, this.actionType});

  final Supplier? supplier;
  final String? actionType;

  @override
  ConsumerState<SupplierForm> createState() => _SupplierFormState();
}

class _SupplierFormState extends ConsumerState<SupplierForm> {
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();

  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;

    if (supplier != null) {
      _companyNameController.text = supplier.companyName;
      _contactPersonController.text = supplier.contactPerson;
      _emailController.text = supplier.email;
      _contactNumberController.text = supplier.contactNumber;
    }

    _companyNameController.addListener(_checkForChanges);
    _contactPersonController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _contactNumberController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final supplier = widget.supplier;
    if (supplier == null) {
      setState(() {
        _isFormModified = _companyNameController.text.isNotEmpty ||
            _contactPersonController.text.isNotEmpty ||
            _emailController.text.isNotEmpty ||
            _contactNumberController.text.isNotEmpty;
      });
      return;
    }

    final hasChanged = _companyNameController.text != supplier.companyName ||
        _contactPersonController.text != supplier.contactPerson ||
        _emailController.text != supplier.email ||
        _contactNumberController.text != supplier.contactNumber;

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
      switch (widget.actionType) {
        case 'add':
          final newSupplierData = NewSupplier(
            companyName: _companyNameController.text.trim(),
            contactPerson: _contactPersonController.text.trim(),
            email: _emailController.text.trim(),
            contactNumber: _contactNumberController.text.trim(),
            isActive: true
          );

          final newSupplier = await ref.read(supplierFormViewModelProvider).addSupplier(newSupplierData);

          if (!mounted) return;

          GoRouter.of(context).pop();

          switch (newSupplier) {
            case Success():
              GoRouter.of(context).pop();
              ref.refresh(supplierListViewModelProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Supplier added successfully.'))
              );
              break;
            case FailureResult():
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error adding supplier.'))
              );
              break;
          }
          break;
        case 'edit':
          final updatedSupplierData = Supplier(
            id: widget.supplier!.id,
            companyName: _companyNameController.text.trim(),
            contactPerson: _contactPersonController.text.trim(),
            email: _emailController.text.trim(),
            contactNumber: _contactNumberController.text.trim(),
            isActive: widget.supplier!.isActive
          );

          final updatedSupplier = await ref.read(supplierFormViewModelProvider).updateSupplier(updatedSupplierData);

          if (!mounted) return;

          GoRouter.of(context).pop();

          switch (updatedSupplier) {
            case Success():
              GoRouter.of(context).pop();
              ref.refresh(supplierListViewModelProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Supplier added successfully.'))
              );
              break;
            case FailureResult():
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error adding supplier.'))
              );
              break;
          }
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid action type.'))
          );
      }
    } catch (e) {
      if (mounted) {
        GoRouter.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(
                  labelText: 'Contact Person',
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
            ]
          )
        )
      )
    );
  }

  Widget? _setTitle() {
    if (widget.actionType == 'add') {
      return const Text('Add Supplier');
    } else {
      return const Text('Edit Supplier');
    }
  }
}