import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import '../../services/env_service.dart';

class ReadEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(EnvService.fileName);
    final result = EnvService().read(inputFile: file);

    final (
      :host,
      :usernameOrEmail,
      :password,
      :token,
    ) = result;

    logger.sectionMapped(
      level: .verbose,
      title: 'Environment Variables:',
      items: {
        DotenvKey.pbHost: host ?? '<not set>',
        DotenvKey.pbUsername: usernameOrEmail ?? '<not set>',
        DotenvKey.pbPassword: password != null ? '<hidden>' : '<not set>',
        DotenvKey.pbToken: token ?? '<not set>',
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
