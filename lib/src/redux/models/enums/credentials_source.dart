/// Sources for obtaining database connection credentials.
///
/// Defines different methods for retrieving sensitive information
/// required to establish a database connection.
enum CredentialsSource {
  /// Load credentials from a .env file
  dotenv,

  /// Request credentials from user through interactive input
  prompt
  ;

  bool get isDotenv => this == CredentialsSource.dotenv;
  bool get isPrompt => this == CredentialsSource.prompt;

  /// Human-readable title of the credentials source
  String get title {
    switch (this) {
      case dotenv:
        return 'Dotenv File';
      case prompt:
        return 'User Input';
    }
  }

  /// Unique key identifier for the source, used in configuration
  String get key {
    switch (this) {
      case dotenv:
        return 'dotenv';
      case prompt:
        return 'prompt';
    }
  }


  /// Creates a [CredentialsSource] instance from its key identifier
  ///
  /// Throws [ArgumentError] if no source with the given key is found
  ///
  /// Example:
  /// ```dart
  /// final source = CredentialsSource.fromKey('dotenv');
  /// ```
  static CredentialsSource fromKey(String key) =>
      CredentialsSource.values.firstWhere(
        (e) => e.key == key,
        orElse: () => throw ArgumentError(
          'No CredentialsSource found for key: $key',
        ),
      );

  /// Creates a [CredentialsSource] instance from its title
  ///
  /// Throws [ArgumentError] if no source with the given title is found
  ///
  /// Example:
  /// ```dart
  /// final source = CredentialsSource.fromTitle('Dotenv File');
  /// ```
  static CredentialsSource fromTitle(String title) =>
      CredentialsSource.values.firstWhere(
        (e) => e.title == title,
        orElse: () => throw ArgumentError(
          'No CredentialsSource found for title: $title',
        ),
      );
}
