import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ims_mobile/domain/entities/item/item.dart';
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
    if (item == null) {
      setState(() {
        _isFormModified = _itemNameController.text.isNotEmpty ||
            _itemCategoryController.text.isNotEmpty ||
            _itemLocationController.text.isNotEmpty ||
            _itemReorderLevelController.text.isNotEmpty ||
            _itemTargetStockLevelController.text.isNotEmpty ||
            _itemCurrentStockLevelController.text.isNotEmpty;
      });
      return;
    }

    final hasChanged = _itemNameController.text != item.itemName ||
        _itemCategoryController.text != item.category ||
        _itemLocationController.text != item.location ||
        _itemReorderLevelController.text != item.reorderLevel.toString() ||
        _itemTargetStockLevelController.text != item.targetStockLevel.toString() ||
        _itemCurrentStockLevelController.text != item.currentStockLevel.toString();

    setState(() {
      _isFormModified = hasChanged;
    });
  }

  Future<void> _onSave() async {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSupplier = ref.watch(selectedSupplierProvider);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                          decoration: const InputDecoration(
                            labelText: 'Current Stock',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _itemTargetStockLevelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Target Stock',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _itemReorderLevelController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reorder Level',
                      border: OutlineInputBorder(),
                    ),
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