import 'package:mason_logger/mason_logger.dart';

import 'credentials.dart';
import 'setup.dart';

/// Factory class for creating input handler instances.
///
/// This factory provides a centralized way to create different types of
/// input handlers with a shared logger configuration. It ensures consistent
/// behavior across all user interaction components.
///
/// The factory pattern is used here to:
/// - Centralize input handler creation logic
/// - Ensure consistent logger usage across all input handlers
/// - Provide a clean abstraction for dependency injection
/// - Make testing easier by allowing mock implementations
///
/// Example usage:
/// ```dart
/// final logger = Logger();
/// final inputsFactory = InputsFactory(logger);
/// final setupInput = inputsFactory.createSetupInput();
/// final credentialsInput = inputsFactory.createCredentialsInput();
/// // Use the input handlers for user interactions
/// final collections = setupInput.chooseCollections(choices: ['users']);
/// final host = credentialsInput.promptHost();
/// ```
final class InputsFactory {
  /// Creates a new inputs factory with the specified logger.
  ///
  /// [_logger] The logger instance that will be shared across all
  /// input handlers created by this factory.
  InputsFactory(this._logger);

  /// The logger instance shared across all input handlers.
  final Logger _logger;

  /// Creates a new setup input handler.
  ///
  /// Returns a [SetupInput] implementation that uses the factory's
  /// logger for user interactions during the setup process.
  ///
  /// Example:
  /// ```dart
  /// final setupInput = inputsFactory.createSetupInput();
  /// final selectedCollections = setupInput.chooseCollections(
  ///   choices: ['users', 'posts', 'comments'],
  /// );
  /// ```
  SetupInput createSetupInput() => ConsoleSetupInput(_logger);

  /// Creates a new credentials input handler.
  ///
  /// Returns a [CredentialsInput] implementation that uses the factory's
  /// logger for secure credential collection from users.
  ///
  /// Example:
  /// ```dart
  /// final credentialsInput = inputsFactory.createCredentialsInput();
  /// final host = credentialsInput.promptHost();
  /// final username = credentialsInput.promptUsername();
  /// final password = credentialsInput.promptPassword(hidden: true);
  /// ```
  CredentialsInput createCredentialsInput() => ConsoleCredentialsInput(_logger);
}
