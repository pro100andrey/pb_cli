import 'package:mason_logger/mason_logger.dart';

/// Abstract interface for credential input operations.
///
/// This interface defines the contract for gathering PocketBase authentication
/// credentials from users. Implementations should provide secure methods for
/// collecting sensitive information like passwords and connection details.
abstract interface class CredentialsInput {
  /// Prompts the user to enter a PocketBase host URL.
  ///
  /// [defaultValue] Optional default host URL to pre-populate the prompt.
  ///
  /// Returns the host URL entered by the user, trimmed of whitespace.
  ///
  /// Example:
  /// ```dart
  /// final host = credentialsInput.promptHost(
  ///   defaultValue: 'http://localhost:8090',
  /// );
  /// // Returns: 'https://api.example.com'
  /// ```
  String promptHost({String? defaultValue});

  /// Prompts the user to enter a superuser username or email.
  ///
  /// [defaultValue] Optional default username/email to pre-populate the prompt.
  ///
  /// Returns the username or email entered by the user, trimmed of whitespace.
  ///
  /// Example:
  /// ```dart
  /// final username = credentialsInput.promptUsername(
  ///   defaultValue: 'admin@example.com',
  /// );
  /// // Returns: 'user@domain.com'
  /// ```
  String promptUsername({String? defaultValue});

  /// Prompts the user to enter a superuser password.
  ///
  /// [defaultValue] Optional default password to pre-populate the prompt.
  /// [hidden] Whether to hide the password input (default: true).
  ///
  /// Returns the password entered by the user.
  ///
  /// Example:
  /// ```dart
  /// final password = credentialsInput.promptPassword(hidden: true);
  /// // Returns: 'secretpassword' (hidden during input)
  /// ```
  String promptPassword({String? defaultValue, bool hidden = true});
}

/// Console-based credential input implementation.
///
/// This class provides a terminal-based interface for securely gathering
/// PocketBase authentication credentials from users. It supports password
/// hiding and default value suggestions for improved user experience.
///
/// Example usage:
/// ```dart
/// final logger = Logger();
/// final credentialsInput = ConsoleCredentialsInput(logger);
///
/// final host = credentialsInput.promptHost();
/// final username = credentialsInput.promptUsername();
/// final password = credentialsInput.promptPassword(hidden: true);
/// ```
final class ConsoleCredentialsInput implements CredentialsInput {
  /// Creates a new console-based credentials input handler.
  ///
  /// [_logger] The logger instance used for creating interactive prompts.
  ConsoleCredentialsInput(this._logger);

  /// The logger instance used for user interactions.
  final Logger _logger;

  @override
  String promptHost({String? defaultValue}) => _logger
      .prompt('Enter PocketBase host URL:', defaultValue: defaultValue)
      .trim();

  @override
  String promptUsername({String? defaultValue}) => _logger
      .prompt('Enter superuser username/email:', defaultValue: defaultValue)
      .trim();

  @override
  String promptPassword({String? defaultValue, bool hidden = true}) =>
      _logger.prompt(
        'Enter superuser password:',
        hidden: hidden,
        defaultValue: defaultValue,
      );
}
