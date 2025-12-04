import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../services/env_service.dart';

final class SaveEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDirPath!.joinFile(EnvService.fileName);
    final host = select.host;
    final usernameOrEmail = select.usernameOrEmail;
    final password = select.password;
    final token = select.token;

    EnvService.write(
      outputFile: file,
      host: host,
      usernameOrEmail: usernameOrEmail,
      password: password,
      token: token,
    );

    logger.sectionMapped(
      level: .verbose,
      title: 'Environment',
      items: {
        DotenvKey.pbHost: ?host,
        DotenvKey.pbUsername: ?usernameOrEmail,
        if (password != null) DotenvKey.pbPassword: '<hidden>',
        DotenvKey.pbToken: ?token,
      },
    );

    return state.copyWith.env(
      host: host,
      usernameOrEmail: usernameOrEmail,
      password: password,
      token: token,
    );
  }
}
