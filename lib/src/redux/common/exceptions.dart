import 'package:cli_async_redux/cli_async_redux.dart';

final class PathIsNotADirectoryException extends ReduxException {
  PathIsNotADirectoryException(String path)
    : super.io(
        message:
            'The path $path is not a directory. '
            'Please provide a valid directory path.',
      );
}

final class PathNotFoundException extends ReduxException {
  PathNotFoundException(String path)
    : super.io(
        message:
            'Path not found: $path. '
            'Please ensure the path is correct and try again.',
      );
}

final class ValidationException extends ReduxException {
  ValidationException(String message) : super.config(message: message);
}

final class ConnectionException extends ReduxException {
  ConnectionException(String message) : super.noHost(message: message);
}
