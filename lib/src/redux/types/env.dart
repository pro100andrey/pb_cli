import 'package:meta/meta.dart';

/// Environment variable keys used in .env files for PocketBase credentials.
///
/// Provides compile-time safety by restricting the set of valid keys
/// to predefined constants.
extension type const EnvKey._(String value) implements String {
  /// Creates an [EnvKey] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not a known key.
  factory EnvKey(String value) {
    if (!_known.contains(value)) {
      throw ArgumentError('Unknown EnvKey: $value');
    }

    return EnvKey._(value);
  }

  /// Host key for PocketBase instance.
  static const pbHost = EnvKey._('PB_HOST');

  /// Username or email key for PocketBase authentication.
  static const pbUsername = EnvKey._('PB_USERNAME');

  /// Password key for PocketBase authentication.
  static const pbPassword = EnvKey._('PB_PASSWORD');

  /// Token key for PocketBase authentication.
  static const pbToken = EnvKey._('PB_TOKEN');

  /// Set of all known [EnvKey]s.
  static const Set<EnvKey> _known = {pbHost, pbUsername, pbPassword, pbToken};
}

/// Environment data structure representing .env file key-value pairs.
///
/// Provides type-safe access to environment variables with convenient getters.
extension type EnvData._(Map<EnvKey, String> data) implements Map {
  /// Creates an empty [EnvData] instance.
  const EnvData.empty() : data = const {};

  /// Creates an [EnvData] instance from a map of key-value pairs.
  factory EnvData.data(Map<EnvKey, String> data) => EnvData._(data);

  /// Returns the value for the [EnvKey.pbHost] key.
  String? get host => data[EnvKey.pbHost];

  /// Returns the value for the [EnvKey.pbUsername] key.
  String? get usernameOrEmail => data[EnvKey.pbUsername];

  /// Returns the value for the [EnvKey.pbPassword] key.
  String? get password => data[EnvKey.pbPassword];

  /// Returns the value for the [EnvKey.pbToken] key.
  String? get token => data[EnvKey.pbToken];

  /// Map operator to access values by [EnvKey].
  @redeclare
  String? operator [](EnvKey? key) => data[key];

  /// Map operator to set values by [EnvKey].
  @redeclare
  void operator []=(EnvKey key, String value) {
    data[key] = value;
  }

  /// Checks if all required credentials are present in the environment data.
  bool get hasData =>
      host != null &&
      usernameOrEmail != null &&
      password != null &&
      token != null;
}
