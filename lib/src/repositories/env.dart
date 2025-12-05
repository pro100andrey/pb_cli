import 'package:cli_utils/cli_utils.dart';

import '../redux/types/env.dart';

abstract interface class EnvRepository {
  factory EnvRepository() => const _FileEnvRepository();

  EnvData read({required DirectoryPath dataDir});

  void write({required EnvData dotenv, required DirectoryPath dataDir});
}

final class _FileEnvRepository implements EnvRepository {
  const _FileEnvRepository();

  static const file = '.env';

  FilePath _file(DirectoryPath dataDir) => dataDir.joinFile(file);

  @override
  EnvData read({required DirectoryPath dataDir}) {
    final file = _file(dataDir);
    final data = _readEnv(file);

    return EnvData.data(data);
  }

  @override
  void write({required EnvData dotenv, required DirectoryPath dataDir}) {
    final file = _file(dataDir);
    _writeEnv(dotenv.data, file);
  }
}

void _writeEnv(Map<EnvKey, String> data, FilePath envFile) {
  // 1. Read existing .env data with merge priority to new data
  final envData = _readEnv(envFile)..addAll(data);
  // 2. Write back to .env file
  final buffer = StringBuffer();
  for (final entry in envData.entries) {
    buffer.writeln('${entry.key}=${entry.value}');
  }
  envFile.writeAsString(buffer.toString());
}

Map<EnvKey, String> _readEnv(FilePath envFile) {
  final envData = <EnvKey, String>{};

  if (!envFile.notFound) {
    final lines = envFile.readAsLines();
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
