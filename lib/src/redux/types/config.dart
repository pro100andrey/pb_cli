import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../models/enums/credentials_source.dart';

/// Configuration keys used in config.json file.
///
/// Provides compile-time safety by restricting the set of valid keys
/// to predefined constants.
extension type const ConfigKey._(String value) implements String {
  /// Creates a [ConfigKey] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not a known key.
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

  /// Set of all known [ConfigKey]s.
  static const Set<ConfigKey> _known = {managedCollections, credentialsSource};
}

/// Configuration data structure representing config.json key-value pairs.
///
/// Provides type-safe access to configuration values with convenient getters.
extension type ConfigData._(Map<ConfigKey, Object?> data) implements Map {
  /// Creates an empty [ConfigData] instance.
  const ConfigData.empty() : data = const {};

  /// Creates a [ConfigData] instance from a map of key-value pairs.
  factory ConfigData.data(Map<ConfigKey, Object?> data) => ConfigData._(data);

  /// Returns the list of managed collections.
  ///
  /// Returns an empty list if not configured.
  IList<String> get managedCollections {
    final collections = data[ConfigKey.managedCollections];
    return switch (collections) {
      null => const IListConst([]),
      List() => collections.cast<String>().lock,
      _ => throw const FormatException(
        'Invalid format for managedCollections. Should be a list of strings.',
      ),
    };
  }

  /// Returns the credentials source configuration.
  ///
  /// Returns [CredentialsSource.prompt] if not configured.
  CredentialsSource get credentialsSource {
    final source = data[ConfigKey.credentialsSource];
    return switch (source) {
      String() => CredentialsSource.fromKey(source),
      null => CredentialsSource.prompt,
      _ => throw const FormatException(
        'Invalid format for credentialsSource. Should be a string.',
      ),
    };
  }

  /// Map operator to access values by [ConfigKey].
  @redeclare
  Object? operator [](ConfigKey? key) => data[key];

  /// Map operator to set values by [ConfigKey].
  @redeclare
  void operator []=(ConfigKey key, Object? value) {
    data[key] = value;
  }
}
