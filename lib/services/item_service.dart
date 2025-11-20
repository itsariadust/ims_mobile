import 'package:dio/dio.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/item/item_api_model.dart';

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
}