import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';
import 'package:ims_mobile/services/user_service.dart';

import '../core/errors/failures.dart';
import '../core/typedefs/result.dart';

final userRepositoryProvider = Provider<UserRespository>((ref) {
  final userService = ref.watch(userServiceProvider);

  return UserRespository(userService);
});

class UserRespository {
  final UserService _userService;

  UserRespository(this._userService);

  Future<Result<Employee>> getProfile() async {
    try {
      final profileResponse = await _userService.fetchUserProfile();

      final profile = Employee.toEmployee(profileResponse);

      return Success(profile);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return FailureResult(AuthFailure(message: 'Session expired. Please log in again.'));
      }

      return FailureResult(ServerFailure(message: e.message ?? 'An unknown server error occurred.'));
    } catch (e) {
      return FailureResult(UnknownFailure(message: 'An unexpected error occurred: ${e.runtimeType}'));
    }
  }
}