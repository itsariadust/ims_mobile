import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ims_mobile/core/errors/failures.dart';
import 'package:ims_mobile/core/typedefs/result.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Result<Session?>> getSession() async {
    try {
      final session = _client.auth.currentSession;
      return Success(session);
    } catch (e) {
      return FailureResult(ServerFailure(message: 'Failed to fetch session: $e'));
    }
  }

  Future<Result<User>> login(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        return Success(res.user!);
      } else {
        return FailureResult(AuthFailure(message: 'Invalid credentials'));
      }
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } catch (e) {
      return FailureResult(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}