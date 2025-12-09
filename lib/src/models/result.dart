/// A type that represents either success or failure.
///
/// [Result] is a sealed class that can be either a [SuccessResult] containing
/// a value of type [T], or a [FailureResult] containing an error of type [E].
///
/// This pattern is useful for handling operations that can fail without
/// throwing exceptions.
///
/// Example:
/// ```dart
/// Result<String, String> parseNumber(String input) {
///   final number = int.tryParse(input);
///   if (number != null) {
///     return Result.success(number.toString());
///   } else {
///     return Result.failure('Invalid number format');
///   }
/// }
/// ```
sealed class Result<T, E> {
  const Result();

  /// Creates a successful result containing the given [value].
  factory Result.success(T value) = SuccessResult<T, E>;

  /// Creates a failure result containing the given [error].
  factory Result.failure(E error) = FailureResult<T, E>;

  /// Transforms the success value using [successMapper] if this is a success,
  /// otherwise returns a failure with the same error.
  ///
  /// This method allows you to chain operations on successful results while
  /// preserving failures.
  Result<R, E> map<R>(R Function(T value) successMapper);

  /// Transforms the error value using [errorMapper] if this is a failure,
  /// otherwise returns a success with the same value.
  ///
  /// This method allows you to transform error types while preserving
  /// successful results.
  Result<T, R> mapError<R>(R Function(E error) errorMapper);

  /// Processes the result by applying [onSuccess] if it's a success,
  /// or [onFailure] if it's a failure.
  ///
  /// This method forces handling of both success and failure cases.
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure);

  /// Returns the success value if this is a [SuccessResult].
  ///
  /// Throws [StateError] if this is a [FailureResult].
  ///
  /// Example:
  /// ```dart
  /// final result = Result.success(42);
  /// print(result.value); // 42
  /// final failedResult = Result.failure('error');
  /// print(failedResult.value); // null
  /// ```
  /// Throws [StateError] if this is a [FailureResult].
  T get value {
    if (this case SuccessResult<T, E>(value: final val)) {
      return val;
    }

    throw StateError('Result is a failure: $this');
  }

  /// Returns the success value if this is a [SuccessResult] otherwise returns
  /// null
  ///
  /// Example:
  /// ```dart
  /// final result = Result.success(42);
  /// print(result.value); // 42
  /// final failedResult = Result.failure('error');
  /// print(failedResult.error); // null
  /// ```
  E? get error {
    if (this case FailureResult<T, E>(error: final err)) {
      return err;
    }

    return null;
  }

  /// Returns the value if this is a success, otherwise returns [defaultValue].
  ///
  /// This is useful when you want to provide a fallback value for failed
  /// operations.
  ///
  /// Example:
  /// ```dart
  /// final result = Result.failure('error');
  /// final value = result.getOrElse(() => 'default');
  /// print(value); // 'default'
  /// ```
  T getOrElse(T Function() defaultValue) =>
      fold((value) => value, (_) => defaultValue());

  /// Returns `true` if this is a [SuccessResult], otherwise `false`.
  bool get isSuccess => this is SuccessResult<T, E>;

  /// Returns `true` if this is a [FailureResult], otherwise `false`.
  bool get isFailure => this is FailureResult<T, E>;
}

/// A successful result containing a [value] of type [T].
///
/// This class represents the success case of a [Result] operation.
final class SuccessResult<T, E> extends Result<T, E> {
  /// Creates a successful result with the given [value].
  const SuccessResult(this.value);

  /// The successful value.
  @override
  final T value;

  @override
  Result<R, E> map<R>(R Function(T value) successMapper) =>
      SuccessResult<R, E>(successMapper(value));

  @override
  Result<T, R> mapError<R>(R Function(E error) errorMapper) =>
      SuccessResult<T, R>(value);

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) =>
      onSuccess(value);

  @override
  String toString() => 'SuccessResult($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuccessResult<T, E> && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// A failure result containing an [error] of type [E].
///
/// This class represents the failure case of a [Result] operation.
final class FailureResult<T, E> extends Result<T, E> {
  /// Creates a failure result with the given [error].
  const FailureResult(this.error);

  /// The error value.

  @override
  final E error;

  @override
  Result<R, E> map<R>(R Function(T value) successMapper) =>
      FailureResult<R, E>(error);

  @override
  Result<T, R> mapError<R>(R Function(E error) errorMapper) =>
      FailureResult<T, R>(errorMapper(error));

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) =>
      onFailure(error);

  @override
  String toString() => 'FailureResult($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T, E> && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
