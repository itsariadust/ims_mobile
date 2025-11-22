import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/item/edit_item.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
import 'package:ims_mobile/domain/entities/item/new_item.dart';
import 'package:ims_mobile/viewmodels/item/item_detail_viewmodel.dart';
import 'package:ims_mobile/viewmodels/item/item_form_viewmodel.dart';
import 'package:ims_mobile/viewmodels/item/item_list_viewmodel.dart';
import 'package:ims_mobile/viewmodels/supplier/selected_supplier.dart';
import 'package:ims_mobile/views/pages/items/supplier_field.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({super.key, this.item, this.actionType});

  final Item? item;
  final String? actionType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _itemCategoryController = TextEditingController();
  final _itemLocationController = TextEditingController();
  final _itemReorderLevelController = TextEditingController();
  final _itemTargetStockLevelController = TextEditingController();
  final _itemCurrentStockLevelController = TextEditingController();

  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;

    if (item != null) {
      _itemNameController.text = item.itemName;
      _itemCategoryController.text = item.category;
      _itemLocationController.text = item.location;
      _itemReorderLevelController.text = item.reorderLevel.toString();
      _itemTargetStockLevelController.text = item.targetStockLevel.toString();
      _itemCurrentStockLevelController.text = item.currentStockLevel.toString();
    }
    
    _itemNameController.addListener(_checkForChanges);
    _itemCategoryController.addListener(_checkForChanges);
    _itemLocationController.addListener(_checkForChanges);
    _itemReorderLevelController.addListener(_checkForChanges);
    _itemTargetStockLevelController.addListener(_checkForChanges);
    _itemCurrentStockLevelController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemCategoryController.dispose();
    _itemLocationController.dispose();
    _itemReorderLevelController.dispose();
    _itemTargetStockLevelController.dispose();
    _itemCurrentStockLevelController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final item = widget.item;

    bool areValuesValid = true;
    if (widget.actionType != 'edit') {
      final current = int.tryParse(_itemCurrentStockLevelController.text) ?? 0;
      final target = int.tryParse(_itemTargetStockLevelController.text) ?? 0;
      final reorder = int.tryParse(_itemReorderLevelController.text) ?? 0;

      if (current <= 0 || target < 0 || reorder < 0) {
        areValuesValid = false;
      }
    }

    bool hasChanged = false;
    if (item == null) {
      hasChanged = _itemNameController.text.isNotEmpty ||
            _itemCategoryController.text.isNotEmpty ||
            _itemLocationController.text.isNotEmpty ||
            _itemReorderLevelController.text.isNotEmpty ||
            _itemTargetStockLevelController.text.isNotEmpty ||
            _itemCurrentStockLevelController.text.isNotEmpty;
    } else {
      hasChanged = _itemNameController.text != item.itemName ||
          _itemCategoryController.text != item.category ||
          _itemLocationController.text != item.location ||
          _itemReorderLevelController.text != item.reorderLevel.toString() ||
          _itemTargetStockLevelController.text != item.targetStockLevel.toString() ||
          _itemCurrentStockLevelController.text != item.currentStockLevel.toString();
    }

    setState(() {
      _isFormModified = hasChanged && areValuesValid;
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
          final newItemData = NewItem(
            itemName: _itemNameController.text.trim(),
            category: _itemCategoryController.text.trim(),
            location: _itemLocationController.text.trim(),
            supplierId: ref.watch(selectedSupplierProvider)!.id,
            reorderLevel: int.parse(_itemReorderLevelController.text.trim()),
            targetStockLevel: int.parse(_itemTargetStockLevelController.text.trim()),
            currentStockLevel: int.parse(_itemCurrentStockLevelController.text.trim()),
            isActive: true
          );

          final newItem = await ref.read(itemFormViewModelProvider).addItem(newItemData);

          if (!mounted) return;

          GoRouter.of(context).pop();
          switch (newItem) {
            case Success():
              GoRouter.of(context).pop();
              ref.refresh(itemListViewModelProvider.notifier).refresh();
              ref.invalidate(selectedSupplierProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item added successfully.'))
              );
              break;
            case FailureResult():
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error adding item.'))
              );
              break;
          }
          break;
        case 'edit':
          final updatedItemData = EditItem(
            itemName: _itemNameController.text.trim(),
            category: _itemCategoryController.text.trim(),
            location: _itemLocationController.text.trim(),
            supplierId: ref.watch(selectedSupplierProvider)?.id ?? widget.item!.supplier.id,
            isActive: widget.item!.isActive
          );

          final updatedItem = await ref.read(itemFormViewModelProvider).editItem(updatedItemData, widget.item!.id);

          if (!mounted) return;

          GoRouter.of(context).pop();

          switch (updatedItem) {
            case Success():
              GoRouter.of(context).pop();
              ref.refresh(itemListViewModelProvider.notifier).refresh();
              ref.invalidate(itemDetailViewModelProvider);
              ref.invalidate(selectedSupplierProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item updated successfully.'))
              );
              break;
            case FailureResult():
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error updating item.'))
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
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.actionType!),
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _itemCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _itemLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SupplierFieldComponent(supplier: widget.item?.supplier),

                // Only show these when in add mode
                if (widget.actionType != 'edit') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _itemCurrentStockLevelController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Current Stock',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final val = int.tryParse(value!) ?? 0;
                            if (val < 0) {
                              return 'Must be a positive integer';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _itemTargetStockLevelController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Target Stock',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final val = int.tryParse(value!) ?? 0;
                            if (val < 0) {
                              return 'Must be a positive integer';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _itemReorderLevelController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Reorder Level',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final val = int.tryParse(value!) ?? 0;
                      if (val < 0) {
                        return 'Must be a positive integer';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _setTitle() {
    if (widget.actionType == 'add') {
      return const Text('Add Item');
    } else {
      return const Text('Edit Item Metadata');
    }
  }
}