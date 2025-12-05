import 'package:cli_utils/cli_utils.dart';

import '../types/env.dart';

final class EnvService {
  const EnvService._();
  static const String fileName = '.env';

  /// Write environment variables to .env file.
  /// Only writes non-null values.
  static void write({
    required FilePath outputFile,
    required EnvData variables,
  }) {
    _write(variables.data, outputFile);
  }

  /// Read environment variables from .env file.
  /// Returns empty map if file doesn't exist or is empty.
  static EnvData read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return const EnvData.empty();
    }

    return EnvData.data(_read(file: inputFile));
  }

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
