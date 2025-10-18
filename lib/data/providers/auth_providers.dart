import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ims_mobile/core/storage/token_storage.dart';
import 'package:ims_mobile/data/services/auth_service.dart';

final secureStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  return AuthService(dio, storage);
});