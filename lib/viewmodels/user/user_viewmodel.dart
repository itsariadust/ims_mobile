import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/repositories/implementation/user_repository.dart';

final userViewModelProvider = AsyncNotifierProvider<UserViewModel, Employee?>(
  UserViewModel.new,
);

class UserViewModel extends AsyncNotifier<Employee?>{
  late final UserRespository _userRepository;

  @override
  Future<Employee> build() async {
    _userRepository = ref.watch(userRepositoryProvider);

    return await _fetchProfile();
  }

  Future<Employee> _fetchProfile() async {
    final profile = await _userRepository.getProfile();

    return switch (profile) {
      Success(value: final employee) => employee,
      FailureResult(failure: final failure) => throw failure,
    };
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfile());
  }

  void clearProfile() {
    state = AsyncValue.data(null);
  }
}