import '../models/dotenv.dart';
import '../utils/path.dart';

abstract interface class EnvRepository {
  const EnvRepository();

  Dotenv readEnv();
  void writeEnv(Dotenv dotenv);
}

final class FileEnvRepository implements EnvRepository {
  const FileEnvRepository(this._dataDir);

  final DirectoryPath _dataDir;

  static const file = '.env';

  FilePath get _envFile => _dataDir.joinFile(file);

  @override
  Dotenv readEnv() {
    final data = _readEnv(_envFile);

    return Dotenv(data);
  }

  @override
  void writeEnv(Dotenv dotenv) {
    _writeEnv(dotenv.data, _envFile);
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
