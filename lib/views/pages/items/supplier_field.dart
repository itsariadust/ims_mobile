import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ims_mobile/domain/entities/supplier/supplier.dart';
import 'package:ims_mobile/viewmodels/supplier/selected_supplier.dart';
import 'package:ims_mobile/viewmodels/supplier/supplier_field_viewmodel.dart';

class SupplierFieldComponent extends ConsumerStatefulWidget {
  const SupplierFieldComponent({super.key, this.supplier});

  final Supplier? supplier;

  @override
  ConsumerState<SupplierFieldComponent> createState() => _SupplierFieldComponentState();
}

class _SupplierFieldComponentState extends ConsumerState<SupplierFieldComponent> {
  final TextEditingController _supplierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _supplierController.text = widget.supplier?.companyName ?? '';
  }

  @override
  void dispose() {
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supplierFieldViewModel = ref.watch(supplierFieldViewModelProvider.notifier);

    return TypeAheadField<Supplier>(
      controller: _supplierController,
      suggestionsCallback: (String query) => supplierFieldViewModel.searchSuppliers(query),
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: _supplierController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Supplier',
            border: OutlineInputBorder(),
          )
        );
      },
      itemBuilder: (BuildContext context, Supplier value) {
        return ListTile(
          title: Text(value.companyName),
        );
      },
      onSelected: (Supplier supplier) {
        _supplierController.text = supplier.companyName;

        ref.read(selectedSupplierProvider.notifier).selectSupplier(supplier);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${supplier.companyName}'),
          ),
        );
      },
      loadingBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      hideOnLoading: false,
      hideOnEmpty: true,
      hideOnError: true,
    );
  }
}