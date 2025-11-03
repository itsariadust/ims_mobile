import 'package:ims_mobile/core/errors/failures.dart';
import 'package:ims_mobile/core/typedefs/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

const String functionName = 'deactivate_user';

Future<Result> deactivateUser(String uuid) async {
  final String? jwt = supabase.auth.currentSession?.accessToken;

  final Map<String, dynamic> requestBody = {
    'uuid': uuid,
  };

  if (jwt == null) {
    return FailureResult(AuthFailure(message: 'No JWT token found'));
  }

  final Map<String, String> headers = {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  };

  try {
    final response = await supabase.functions.invoke(
      functionName,
      body: requestBody,
      headers: headers,
      method: HttpMethod.post,
    );

    if (response.status == 200 && response.data != null) {
      return Success(response.data);
    } else {
      final errorData = response.data as Map<String, dynamic>?;
      return FailureResult(ServerFailure(message: 'Function Error (${response.status}): ${errorData?['error'] ?? 'Unknown error'}'));
    }
  } catch (e) {
    return FailureResult(UnknownFailure(message: 'An unexpected error occurred: $e'));
  }
}