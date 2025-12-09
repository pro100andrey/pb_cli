import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../env/env_state.dart';
import '../../session/actions/populate_session_from_env_action.dart';
import '../../types/env.dart';
import '../env_persistence.dart';

/// Loads environment variables from .env file into [EnvState].
///
/// Reads the .env file from the working directory and stores the raw
/// key-value pairs in the state. If the file doesn't exist, stores
/// an empty [EnvData].
///
/// This action only loads the file content - it doesn't populate
/// the session state. Use [PopulateSessionFromEnvAction] for that.
final class LoadEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDirPath!.joinFile('.env');
    final data = readEnv(file: file);

    logger.sectionMapped(
      level: .verbose,
      title: 'Environment Variables:',
      items: {
        EnvKey.pbHost: data.host ?? '<not set>',
        EnvKey.pbUsername: data.usernameOrEmail ?? '<not set>',
        EnvKey.pbPassword: data.password != null ? '<hidden>' : '<not set>',
        EnvKey.pbToken: data.token ?? '<not set>',
      },
    );

    return state.copyWith.env(data: data);
  }
}
