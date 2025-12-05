import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';

import '../types/config.dart';

/// Service for reading and writing config.json files containing
/// CLI configuration.
///
/// Handles:
/// - Reading configuration from config.json file
/// - Writing configuration to config.json file
/// - JSON serialization/deserialization
final class ConfigService {
  const ConfigService._();

  /// The standard config file name.
  static const fileName = 'config.json';

  /// Reads configuration from config.json file.
  ///
  /// Returns [ConfigData.empty()] if the file doesn't exist.
  static ConfigData read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return const ConfigData.empty();
    }

    return ConfigData.data(_read(file: inputFile));
  }

  /// Writes configuration to config.json file.
  ///
  /// Serializes [data] to JSON with pretty printing (2-space indent).
  static void write({required FilePath outputFile, required ConfigData data}) {
    _write(data.data, outputFile);
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
