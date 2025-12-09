import 'package:cli_async_redux/cli_async_redux.dart';

/// Exception thrown when a path exists but is not a directory.
///
/// Used by guards to validate that working directory paths
/// point to actual directories.
final class PathIsNotADirectoryException extends ReduxException {
  PathIsNotADirectoryException(String path)
    : super.io(
        message:
            'The path $path is not a directory. '
            'Please provide a valid directory path.',
      );
}

/// Exception thrown when a directory cannot be created.
///
/// Used by guards to validate that directories can be created
/// if they don't exist (e.g., parent directory exists and is writable).
final class PathCannotBeCreatedException extends ReduxException {
  PathCannotBeCreatedException(String path)
    : super.io(
        message:
            'Cannot create directory at $path. '
            'Please ensure the parent directory exists '
            'and you have write permissions.',
      );
}

/// Exception thrown when a required path does not exist.
///
/// Used by guards to validate that required paths exist
/// before performing operations on them.
final class PathNotFoundException extends ReduxException {
  PathNotFoundException(String path)
    : super.io(
        message:
            'Path not found: $path. '
            'Please ensure the path is correct and try again.',
      );
}

/// Exception thrown when credential validation fails.
///
/// Used when required credentials (host, username, password) are missing
/// or invalid during authentication setup.
final class ValidationException extends ReduxException {
  ValidationException(String message) : super.config(message: message);
}

/// Exception thrown when connection to PocketBase server fails.
///
/// Used when unable to reach the PocketBase instance at the specified host.
final class ConnectionException extends ReduxException {
  ConnectionException(String message) : super.noHost(message: message);
}
