import 'package:cli_utils/cli_utils.dart';

import '../types/env.dart';

/// Service for reading and writing .env files containing
/// PocketBase credentials.
///
/// Handles:
/// - Reading environment variables from .env file
/// - Writing environment variables to .env file
/// - Merging new values with existing file content
/// - Skipping empty lines and comments
final class EnvService {
  const EnvService._();

  /// The standard .env file name.
  static const String fileName = '.env';

  /// Writes environment variables to .env file.
  ///
  /// Merges [env] with existing file content, preserving
  /// other environment variables that may exist in the file.
  /// New values override existing ones with the same key.
  static void write({required FilePath outputFile, required EnvData env}) {
    _write(env.data, outputFile);
  }

  /// Reads environment variables from .env file.
  ///
  /// Returns [EnvData.empty()] if the file doesn't exist or is empty.
  /// Skips empty lines and comments (lines starting with #).
  static EnvData read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return const EnvData.empty();
    }

    return EnvData.data(_read(file: inputFile));
  }

  /// Writes environment data to file, merging with existing content.
  static void _write(Map<EnvKey, String> data, FilePath file) {
    // 1. Read existing .env data with merge priority to new data
    final envData = _read(file: file)..addAll(data);
    // 2. Write back to .env file
    final buffer = StringBuffer();
    for (final entry in envData.entries) {
      buffer.writeln('${entry.key}=${entry.value}');
    }
    file.writeAsString(buffer.toString());
  }

  /// Parses .env file and returns key-value pairs.
  ///
  /// Skips empty lines and comments (lines starting with #).
  /// Only recognizes known [EnvKey] values.
  static Map<EnvKey, String> _read({required FilePath file}) {
    final envData = <EnvKey, String>{};

    if (!file.notFound) {
      final lines = file.readAsLines();
      for (final line in lines) {
        // Skip empty lines or comments
        if (line.trim().isEmpty || line.startsWith('#')) {
          continue;
        }
        // Split at the first '=' to separate key and value
        final parts = line.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          envData[EnvKey(key)] = value;
        }
      }
    }

    return envData;
  }
}
