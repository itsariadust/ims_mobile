import 'package:ims_mobile/core/errors/failures.dart';

sealed class Result<T> {}

// Success result wrapper
class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

// Failure result wrapper
class FailureResult<T> extends Result<T> {
  final Failure failure;
  FailureResult(this.failure);
}