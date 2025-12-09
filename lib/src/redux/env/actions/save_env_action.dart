import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../env/env_state.dart';
import '../../session/session_state.dart';
import '../../types/env.dart';
import '../env_persistence.dart';

/// Saves current session credentials to .env file.
///
/// Takes values from [SessionState] (host, username, password, token)
/// and writes them to the .env file in the working directory.
/// Only non-null values are written.
///
/// This updates both the file on disk and the [EnvState] to reflect
/// the saved values.
///
/// Typically called during setup or after credential changes.
final class SaveEnvAction extends AppAction {
  @override
  AppState reduce() {
    final data = EnvData.data({
      EnvKey.pbHost: ?select.host,
      EnvKey.pbUsername: ?select.usernameOrEmail,
      EnvKey.pbPassword: ?select.password,
      EnvKey.pbToken: ?select.token,
    });

    final file = select.envFilePath;
    writeEnv(data: data, file: file);

    logger.sectionMapped(
      level: .verbose,
      title: 'Environment',
      items: {
        EnvKey.pbHost: data.host ?? '<not set>',
        EnvKey.pbUsername: data.usernameOrEmail ?? '<not set>',
        EnvKey.pbPassword: data.password != null ? '<hidden>' : '<not set>',
        EnvKey.pbToken: data.token != null ? '<hidden>' : '<not set>',
      },
    );

    return state.copyWith.env(data: data);
  }
}
