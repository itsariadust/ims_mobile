import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(apiClientProvider));
});

class UserService {
  final Dio _dio;
  final String _profileEndpoint = '/profile';
  UserService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<EmployeeApiModel> fetchUserProfile() async {
    try {
      final response = await _dio.get(_profileEndpoint);
      return EmployeeApiModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}