import '../redux/models/enums/dotenv.dart';
import '../utils/path.dart';

abstract interface class EnvRepository {
  factory EnvRepository() => const _FileEnvRepository();

  Dotenv read({required DirectoryPath dataDir});

  void write({required Dotenv dotenv, required DirectoryPath dataDir});
}

final class _FileEnvRepository implements EnvRepository {
  const _FileEnvRepository();

  static const file = '.env';

  FilePath _file(DirectoryPath dataDir) => dataDir.joinFile(file);

  @override
  Dotenv read({required DirectoryPath dataDir}) {
    final file = _file(dataDir);
    final data = _readEnv(file);

    return Dotenv.data(data);
  }

  @override
  void write({required Dotenv dotenv, required DirectoryPath dataDir}) {
    final file = _file(dataDir);
    _writeEnv(dotenv.data, file);
  }
}

void _writeEnv(Map<DotenvKey, String> data, FilePath envFile) {
  // 1. Read existing .env data with merge priority to new data
  final envData = _readEnv(envFile)..addAll(data);
  // 2. Write back to .env file
  final buffer = StringBuffer();
  for (final entry in envData.entries) {
    buffer.writeln('${entry.key}=${entry.value}');
  }
  envFile.writeAsString(buffer.toString());
}

Map<DotenvKey, String> _readEnv(FilePath envFile) {
  final envData = <DotenvKey, String>{};

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
        envData[DotenvKey(key)] = value;
      }
    }
  }

  return envData;
}
