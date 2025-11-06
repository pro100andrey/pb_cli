import 'package:mason_logger/mason_logger.dart';

/// Abstract interface for handling setup-related user interactions.
///
/// This interface defines the contract for gathering user input during
/// the initial setup process of the CLI tool. Implementations should
/// provide methods for collecting configuration choices from users.
abstract interface class SetupInput {
  /// Prompts the user to select multiple collections from available options.
  ///
  /// This method allows users to choose which PocketBase collections they
  /// want to manage with the CLI tool. Multiple selections are supported.
  ///
  /// [choices] The list of available collection names to choose from.
  /// [defaultValues] Optional list of pre-selected collection names.
  ///
  /// Returns a list of collection names selected by the user.
  ///
  /// Example:
  /// ```dart
  /// final selected = setupInput.chooseCollections(
  ///   choices: ['users', 'posts', 'comments'],
  ///   defaultValues: ['users'],
  /// );
  /// // Returns: ['users', 'posts']
  /// ```
  List<String> chooseCollections({
    required List<String> choices,
    List<String>? defaultValues,
  });

  /// Prompts the user to select a credentials source.
  ///
  /// This method allows users to choose how they want to provide their
  /// PocketBase authentication credentials (e.g., environment variables
  /// or interactive prompts).
  ///
  /// [choices] The list of available credential source options.
  /// [defaultValue] Optional pre-selected credential source.
  ///
  /// Returns the credential source selected by the user.
  ///
  /// Example:
  /// ```dart
  /// final source = setupInput.chooseCredentialsSource(
  ///   choices: ['Dotenv File', 'User Input'],
  ///   defaultValue: 'Dotenv File',
  /// );
  /// // Returns: 'User Input'
  /// ```
  String chooseCredentialsSource({
    required List<String> choices,
    String? defaultValue,
  });
}

/// Console-based implementation for setup interactions.
///
/// This class provides a terminal-based interface for gathering setup
/// configuration from users. It uses the Mason Logger library to create
/// interactive prompts with support for multiple selections and default values.
///
/// Example usage:
/// ```dart
/// final logger = Logger();
/// final setupInput = ConsoleSetupInput(logger);
///
/// final collections = setupInput.chooseCollections(
///   choices: ['users', 'posts'],
///   defaultValues: ['users'],
/// );
/// ```
final class ConsoleSetupInput implements SetupInput {
  /// Creates a new console-based setup input handler.
  ///
  /// [_logger] The logger instance used for creating interactive prompts.
  ConsoleSetupInput(this._logger);

  /// The logger instance used for user interactions.
  final Logger _logger;

  @override
  List<String> chooseCollections({
    required List<String> choices,
    List<String>? defaultValues,
  }) => _logger.chooseAny(
    'Select collections to synchronize:',
    choices: choices,
    defaultValues: defaultValues ?? [],
  );

  @override
  String chooseCredentialsSource({
    required List<String> choices,
    String? defaultValue,
  }) => _logger.chooseOne(
    'Select authentication method:',
    choices: choices,
    defaultValue: defaultValue,
  );
}
