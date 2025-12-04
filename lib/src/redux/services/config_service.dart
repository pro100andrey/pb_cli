import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';

import '../models/enums/credentials_source.dart';

typedef ReadConfigResult = ({
  List<String>? managedCollections,
  CredentialsSource? credentialsSource,
});

final class ConfigService {
  const ConfigService._();
  static const fileName = 'config.json';

  static ReadConfigResult read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return (managedCollections: null, credentialsSource: null);
    }

    final configMap = _read(file: inputFile);

    final collections = configMap[ConfigKey.managedCollections];
    final managedCollections = switch (collections) {
      null => null,
      List() => collections.cast<String>(),
      _ => throw const FormatException(
        'Invalid format for managedCollections in config file. '
        'Should be a list of strings.',
      ),
    };

    final source = configMap[ConfigKey.credentialsSource];
    final credentialsSource = switch (source) {
      String() => CredentialsSource.fromKey(source),
      null => null,
      _ => throw const FormatException(
        'Invalid format for credentialsSource in config file. '
        'Should be a string.',
      ),
    };

    return (
      credentialsSource: credentialsSource,
      managedCollections: managedCollections,
    );
  }

  static void write({
    required FilePath outputFile,
    required List<String>? managedCollections,
    required CredentialsSource? credentialsSource,
  }) {
    final data = {
      ConfigKey.managedCollections: managedCollections,
      ConfigKey.credentialsSource: credentialsSource?.key,
    };

    _write(data, outputFile);
  }

  static void _write(Map<ConfigKey, Object?> data, FilePath file) {
    final json = const JsonEncoder.withIndent('  ').convert(data);

    file.writeAsString(json);
  }

  static Map<ConfigKey, dynamic> _read({required FilePath file}) {
    final contents = file.readAsString();
    final configMap = jsonDecode(contents) as Map<ConfigKey, dynamic>;

    return configMap;
  }
}

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
