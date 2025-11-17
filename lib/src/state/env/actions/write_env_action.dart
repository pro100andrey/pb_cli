import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import '../../services/env_service.dart';

final class WriteEnvAction extends AppAction {
  WriteEnvAction({
    this.host,
    this.usernameOrEmail,
    this.password,
    this.token,
  });

  final String? host;
  final String? usernameOrEmail;
  final String? password;
  final String? token;

  @override
  AppState reduce() {
    final file = select.workDir.joinFile(EnvService.fileName);

    EnvService().write(
      outputFile: file,
      host: host,
      usernameOrEmail: usernameOrEmail,
      password: password,
      token: token,
    );

    logger.sectionMapped(
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
