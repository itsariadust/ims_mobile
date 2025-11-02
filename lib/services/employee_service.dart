import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';

final employeeServiceProvider = Provider<EmployeeService>((ref) {
  return EmployeeService(ref.watch(apiClientProvider));
});

class EmployeeService {
  final Dio _dio;
  final String _employeeEndpoint = '/employees';
  EmployeeService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<List<EmployeeApiModel>> fetchAllEmployees() async {
    try {
      final response = await _dio.get(_employeeEndpoint);

      final employeesList = (response.data as List)
          .map((e) => EmployeeApiModel.fromJson(e))
          .toList();

      return employeesList;
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<EmployeeApiModel> fetchEmployee(int id) async {
    try {
      final response = await _dio.get('$_employeeEndpoint/$id');

      return EmployeeApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}