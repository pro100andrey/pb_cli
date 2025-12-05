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
