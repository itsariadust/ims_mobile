import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/supplier/new_supplier_api_model.dart';
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

  Future<SupplierApiModel> addSupplier(NewSupplierApiModel supplier) async {
    try {
      final jsonData = supplier.toJson();

      final response = await _dio.post(_supplierEndpoint, data: jsonData);

      return SupplierApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SupplierApiModel> updateSupplier(int id, SupplierApiModel supplier) async {
    try {
      final jsonData = supplier.toJson();

      final response = await _dio.patch('$_supplierEndpoint/$id', data: jsonData);

      return SupplierApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }
}