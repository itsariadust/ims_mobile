import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/network/api_client.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';

final employeeServiceProvider = Provider<EmployeeService>((ref) {
  final service = EmployeeService((ref.watch(apiClientProvider)));
  ref.onDispose(() => service.dispose());
  return service;
});

class EmployeeService {
  final Dio _dio;
  final String _employeeEndpoint = '/employees';

  final _employeeStreamController = StreamController<List<EmployeeApiModel>>.broadcast();
  Timer? _timer;

  EmployeeService(ApiClient apiClient) : _dio = apiClient.dio {
    _startPolling();
  }

  Stream<List<EmployeeApiModel>> getEmployeeStream() {
    return _employeeStreamController.stream;
  }

  Future<void> _fetchAndPushEmployees() async {
    try {
      final employees = await fetchAllEmployees();
      if (!_employeeStreamController.isClosed) {
        _employeeStreamController.add(employees);
      }
    } catch (e) {
      if (!_employeeStreamController.isClosed) {
        _employeeStreamController.addError(e);
      }
    }
  }

  void _startPolling() {
    _fetchAndPushEmployees();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchAndPushEmployees();
    });
  }

  Future<List<EmployeeApiModel>> fetchAllEmployees() async {
    try {
      final response = await _dio.get(_employeeEndpoint);

      final employeesList = (response.data as List)
        .map((e) => EmployeeApiModel.fromJson(e))
        .toList();

      return employeesList;
    } on DioException catch (e) {
      rethrow;
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

  void dispose() {
    _timer?.cancel();
    _employeeStreamController.close();
  }
}