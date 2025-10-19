// lib/core/errors/failures.dart

/// The ABSTRACT base class for all application errors (Failures).
///
/// It ensures all failures carry a descriptive message.
abstract class Failure {
  final String message;

  // Optional: You might include a statusCode or errorCode here
  const Failure({required this.message});

  @override
  String toString() => '$runtimeType: $message';
}

// --------------------------------------------------------------------------
// 1. SERVER FAILURES (Related to API/Network Communication)
// --------------------------------------------------------------------------

/// Failure resulting from a successful request but an unsuccessful response (e.g., 404, 500).
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// A specific type of ServerFailure related to authentication issues (e.g., 401, invalid credentials).
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Failure when the application cannot connect to the internet or API.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

// --------------------------------------------------------------------------
// 2. CACHE/STORAGE FAILURES (Related to local storage)
// --------------------------------------------------------------------------

/// Failure resulting from issues with local data storage (e.g., Secure Storage, SharedPreferences, Hive).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

// --------------------------------------------------------------------------
// 3. APPLICATION/DOMAIN FAILURES (Related to business logic)
// --------------------------------------------------------------------------

/// Failure when user input validation fails.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Generic catch-all failure for unexpected issues.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}