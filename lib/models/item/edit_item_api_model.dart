import 'package:ims_mobile/domain/entities/item/edit_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_item_api_model.g.dart';
@JsonSerializable()
class EditItemApiModel {
  final String itemName;
  final String category;
  final String location;
  final int supplierId;
  final bool isActive;

  EditItemApiModel({
    required this.itemName,
    required this.category,
    required this.location,
    required this.supplierId,
    required this.isActive
  });

  factory EditItemApiModel.fromJson(Map<String, dynamic> json) => _$EditItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditItemApiModelToJson(this);

  EditItem toDomain() {
    return EditItem(
      itemName: itemName,
      category: category,
      location: location,
      supplierId: supplierId,
      isActive: isActive,
    );
  }

  factory EditItemApiModel.fromDomain(EditItem item) {
    return EditItemApiModel(
        itemName: item.itemName,
        category: item.category,
        location: item.location,
        supplierId: item.supplierId,
        isActive: item.isActive
    );
  }
}