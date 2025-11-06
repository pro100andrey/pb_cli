import 'credentials_source.dart';

/// A type-safe representation of configuration keys.
///
/// This extension type wraps a string value and ensures that only known
/// configuration keys can be used. It provides compile-time safety by
/// restricting the set of valid keys to predefined constants.
extension type const ConfigKey._(String value) implements String {
  /// Creates a new ConfigKey from a string value.
  ///
  /// [value] The string value representing the configuration key.
  ///
  /// Throws [ArgumentError] if the provided value is not a known configuration
  /// key.
  factory ConfigKey(String value) {
    if (!_known.contains(value)) {
      throw ArgumentError('Unknown ConfigKey: $value');
    }

    return ConfigKey._(value);
  }

  /// Configuration key for managed collections setting.
  static const managedCollections = ConfigKey._('managedCollections');

  /// Configuration key for credentials source setting.
  static const credentialsSource = ConfigKey._('credentialsSource');

  /// Set of all known configuration keys.
  static const Set<ConfigKey> _known = {
    managedCollections,
    credentialsSource,
  };
}

/// Configuration data structure representing CLI settings.
///
/// This extension type wraps a Map to provide type-safe access to configuration
/// values. It handles serialization and deserialization of configuration data
/// while providing convenient getters and setters for each configuration
/// option.
extension type Config(Map<ConfigKey, Object?> data) {
  /// Creates an empty configuration with no settings.
  Config.empty() : data = {};

  /// Gets the list of managed collections.
  ///
  /// Returns a list of collection names that are managed by the seeder.
  /// If no collections are configured, returns an empty list.
  ///
  /// Throws [FormatException] if the stored value is not a valid list of
  /// strings.
  List<String> get managedCollections {
    final collections = data[ConfigKey.managedCollections];

    return switch (collections) {
      null => [],
      List() => collections.cast(),
      _ => throw const FormatException(
        'Invalid format for managedCollections in config file. '
        'Should be a list of strings.',
      ),
    };
  }

  /// Gets the credentials source configuration.
  ///
  /// Returns the configured source for obtaining database credentials.
  /// If not configured, defaults to [CredentialsSource.prompt].
  ///
  /// Throws [FormatException] if the stored value is not a valid string.
  CredentialsSource get credentialsSource {
    final credentialsSource = data[ConfigKey.credentialsSource];

    return switch (credentialsSource) {
      String() => CredentialsSource.fromKey(credentialsSource),
      null => CredentialsSource.prompt,
      _ => throw const FormatException(
        'Invalid format for credentialsSource in config file. '
        'Should be a string.',
      ),
    };
  }

  Config copyWith({
    List<String>? managedCollections,
    CredentialsSource? credentialsSource,
  }) => Config({
    ConfigKey.managedCollections: managedCollections ?? this.managedCollections,
    ConfigKey.credentialsSource:
        credentialsSource?.key ?? this.credentialsSource.key,
  });
}
