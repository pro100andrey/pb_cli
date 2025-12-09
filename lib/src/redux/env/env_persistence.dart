import 'package:cli_utils/cli_utils.dart';

import '../types/env.dart';

/// Writes environment data to file, merging with existing content.
void writeEnv(EnvData data, FilePath file) {
  // 1. Read existing .env data with merge priority to new data
  final envData = readEnv(file: file)..addAll(data);
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
EnvData readEnv({required FilePath file}) {
  if (file.notFound) {
    return const EnvData.empty();
  }

  final envData = EnvData.data({});

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
