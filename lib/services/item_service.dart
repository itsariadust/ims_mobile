import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/item/item_api_model.dart';
import 'package:ims_mobile/models/item/new_item_api_model.dart';
import 'package:ims_mobile/models/item/edit_item_api_model.dart';

final itemServiceProvider = Provider<ItemService>((ref) {
  return ItemService(ref.watch(apiClientProvider));
});

class ItemService {
  final Dio _dio;
  final String _itemEndpoint = '/items';
  ItemService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<List<ItemApiModel>> fetchAllItems() async {
    try {
      final response = await _dio.get(_itemEndpoint);

      final itemsList = (response.data as List)
          .map((e) => ItemApiModel.fromJson(e))
          .toList();

      return itemsList;
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ItemApiModel> fetchItem(int id) async {
    try {
      final response = await _dio.get('$_itemEndpoint/$id');
      return ItemApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ItemApiModel> addItem(NewItemApiModel newItemModel) async {
    try {
      final jsonData = newItemModel.toJson();
      final response = await _dio.post(_itemEndpoint, data: jsonData);
      return ItemApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<ItemApiModel> editItem(EditItemApiModel editedItemModel, int id) async {
    try {
      final jsonData = editedItemModel.toJson();
      final response = await _dio.patch('$_itemEndpoint/$id', data: jsonData);
      return ItemApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}