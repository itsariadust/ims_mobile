import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/supplier/supplier_api_model.dart';

final supplierServiceProvider = Provider<SupplierService>((ref) {
  return SupplierService(ref.watch(apiClientProvider));
});

class SupplierService {
  final Dio _dio;
  final String _supplierEndpoint = '/suppliers';
  SupplierService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<List<SupplierApiModel>> fetchAllSuppliers() async {
    try {
      final response = await _dio.get(_supplierEndpoint);

      final suppliersList = (response.data as List)
        .map((e) => SupplierApiModel.fromJson(e))
        .toList();

      return suppliersList;
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SupplierApiModel> fetchSupplier(int id) async {
    try {
      final response = await _dio.get('$_supplierEndpoint/$id');
      return SupplierApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}