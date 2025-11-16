import '../../../models/dotenv.dart';
import '../../../utils/path.dart';
import 'action.dart';

const String _fileName = '.env';

final class SaveEnvAction extends AppAction {
  SaveEnvAction({
    required this.host,
    required this.usernameOrEmail,
    required this.password,
    required this.token,
  });

  final String host;
  final String usernameOrEmail;
  final String password;
  final String? token;

  @override
  AppState reduce() {
    final envData = <DotenvKey, String>{
      DotenvKey.pbHost: host,
      DotenvKey.pbUsername: usernameOrEmail,
      DotenvKey.pbPassword: password,
      DotenvKey.pbToken: ?token,
    };

    final file = state.dataDir.joinFile(_fileName);
    _writeEnv(envData, file);

    final updatedEnvData = _readEnv(file);
    final dotenv = Dotenv.data(updatedEnvData);

    return state.copyWith(dotenv: dotenv);
  }
}

class LoadEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = state.dataDir.joinFile(_fileName);
    final envData = _readEnv(file);
    final dotenv = Dotenv.data(envData);

    return state.copyWith(dotenv: dotenv);
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
