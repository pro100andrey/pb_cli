import '../../../models/dotenv.dart';
import 'action.dart';

class LoadEnvAction extends AppAction {
  static const String _fileName = '.env';

  @override
  AppState reduce() {
    final envFile = select.dataDir.joinFile(_fileName);
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

    final dotenv = Dotenv.data(envData);

    return state.copyWith(dotenv: dotenv);
  }
}
