import 'dart:async';

import '../models/result.dart';

const int kSuccess = 0;

/// Represents an application-level failure that can be reported with a
/// specific exit code and message.
///
/// Based on BSD `sysexits.h` standard exit codes:
/// https://man.openbsd.org/sysexits
///
/// Each factory constructor maps to a particular failure type that
/// clearly communicates the cause of failure to the caller or CI system.
class Failure {
  /// Creates a [Failure] with a specific message and exit code.
  const Failure({required this.message, required this.exitCode, this.details});

  /// Generic, unspecified error.
  ///
  /// Use this when no other code fits or for unexpected exceptions.
  /// Typically indicates a bug or unforeseen condition.
  ///
  /// Exit code: **EX_GENERAL = 1**
  Failure.generic({required this.message, this.details}) : exitCode = exGeneric;

  /// User aborted the operation.
  ///
  /// Use this when the user cancels an operation or declines a prompt.
  ///
  /// Exit code: **EX_USER_ABORTED = 2**
  Failure.userAborted({required this.message, this.details})
    : exitCode = exUserAborted;

  /// Command line usage error.
  ///
  /// Use this when required CLI arguments are missing, invalid, or unsupported.
  /// Example: user did not provide mandatory flags or options.
  ///
  /// Exit code: **EX_USAGE = 64**
  Failure.usage({required this.message, this.details}) : exitCode = exUsage;

  /// Data format or type error.
  ///
  /// Use this when input data exists but is invalid, corrupted, or malformed.
  /// Example: JSON/YAML parsing failure, unexpected value type.
  ///
  /// Exit code: **EX_DATAERR = 65**
  Failure.data({required this.message, this.details}) : exitCode = exData;

  /// Input file missing or cannot be opened.
  ///
  /// Use this when a required file does not exist or is inaccessible.
  ///
  /// Exit code: **EX_NOINPUT = 66**
  Failure.noInput({required this.message, this.details}) : exitCode = exNoInput;

  /// Remote host not found or unreachable.
  ///
  /// Use this for DNS resolution errors, unreachable servers, or connection
  /// failures.
  ///
  /// Exit code: **EX_NOHOST = 68**
  Failure.noHost({required this.message, this.details}) : exitCode = exNoHost;

  /// Service or dependency unavailable.
  ///
  /// Use this when a remote API, database, or other dependency is down
  /// or temporarily not responding (e.g., HTTP 503, API outage).
  ///
  /// Exit code: **EX_UNAVAILABLE = 69**
  Failure.unavailable({required this.message, this.details})
    : exitCode = exUnavailable;

  /// Internal software error.
  ///
  /// Use this for unexpected exceptions, logic errors, or internal bugs.
  ///
  /// Exit code: **EX_SOFTWARE = 70**
  Failure.software({required this.message, this.details})
    : exitCode = exSoftware;

  /// I/O failure during read or write operation.
  ///
  /// Use this when reading/writing to disk, stdin/stdout, or network streams
  /// fails unexpectedly.
  ///
  /// Exit code: **EX_IOERR = 74**
  Failure.io({required this.message, this.details}) : exitCode = exIO;

  /// Temporary failure where retry may succeed.
  ///
  /// Use this for transient errors like network timeouts, rate limiting,
  /// or when a resource is temporarily locked.
  ///
  /// Exit code: **EX_TEMPFAIL = 75**
  Failure.temp({required this.message, this.details}) : exitCode = exTempFail;

  /// Permission denied or authentication failure.
  ///
  /// Use this when the user lacks necessary permissions or authentication
  /// fails.
  ///
  /// Exit code: **EX_NOPERM = 77**
  Failure.permission({required this.message, this.details})
    : exitCode = exNoPerm;

  /// Configuration error.
  ///
  /// Use this when configuration files are missing, invalid, or contain
  /// unsupported options.
  ///
  /// Exit code: **EX_CONFIG = 78**
  Failure.config({required this.message, this.details}) : exitCode = exConfig;

  /// Returns a [Failure] corresponding to an HTTP status code.
  ///
  /// Maps HTTP responses to exit codes for CLI usage:
  /// - 400 → usage error (EX_USAGE)
  /// - 401, 403 → permission denied (EX_NOPERM)
  /// - 404 → service unavailable (EX_UNAVAILABLE)
  /// - 408, 429 → temporary failure (EX_TEMPFAIL)
  /// - 500–599 → service unavailable (EX_UNAVAILABLE)
  /// - otherwise → internal software error (EX_SOFTWARE)
  factory Failure.fromHttpStatus(
    int statusCode, {
    String? message,
    Object? details,
  }) {
    message ??= 'HTTP request failed with status $statusCode';

    if (statusCode >= 500 && statusCode < 600) {
      return Failure.unavailable(message: message, details: details);
    }

    switch (statusCode) {
      case 400: // Bad Request - invalid request syntax
        return Failure.usage(message: message, details: details);
      case 401: // Unauthorized - authentication required
      case 403: // Forbidden - access denied
        return Failure.permission(message: message, details: details);
      case 404: // Not Found - resource unavailable
        return Failure.unavailable(message: message, details: details);
      case 408: // Request Timeout - temporary network issue
      case 429: // Too Many Requests - rate limiting
        return Failure.temp(message: message, details: details);
      default: // Unhandled status codes
        return Failure.software(message: message, details: details);
    }
  }

  /// Generic error
  static const int exGeneric = 1;

  /// User aborted the operation.
  static const int exUserAborted = 2;

  /// CLI usage error.
  static const int exUsage = 64;

  /// Invalid data format/type.
  static const int exData = 65;

  /// Input file missing or unreadable.
  static const int exNoInput = 66;

  /// Host not found or unreachable.
  static const int exNoHost = 68;

  /// Service unavailable (e.g., 503, timeout).
  static const int exUnavailable = 69;

  /// Internal software error.
  static const int exSoftware = 70;

  /// I/O failure during read/write operations.
  static const int exIO = 74;

  /// Temporary failure (retry might succeed).
  static const int exTempFail = 75;

  /// Permission denied (e.g., authentication failure).
  static const int exNoPerm = 77;

  /// Configuration file missing or invalid.
  static const int exConfig = 78;

  /// The exit code representing this failure.
  final int exitCode;

  /// The human-readable description of the failure.
  final String message;

  /// Optional additional details about the failure.
  final Object? details;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          exitCode == other.exitCode &&
          details == other.details;

  @override
  int get hashCode => Object.hash(runtimeType, message, exitCode, details);

  @override
  String toString() => 'Failure: $message (exit code: $exitCode)';
}

extension FailureResultExtension on Failure {
  /// Returns a [Result.failure] wrapping this [Failure].
  CliResult<T> asResult<T>() => Result.failure(this);
}

extension SuccessResultExtension<T> on T {
  /// Returns a [Result.success] wrapping this value.
  CliResult<T> asResult() => Result.success(this);
}

/// Type alias for a CLI operation result.
typedef CliResult<T> = Result<T, Failure>;

/// Type alias for a future CLI operation result.
typedef CliFuture<T> = Future<CliResult<T>>;
