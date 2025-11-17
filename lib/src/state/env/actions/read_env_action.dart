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
        'PB_HOST': host ?? '<not set>',
        'PB_USERNAME': usernameOrEmail ?? '<not set>',
        'PB_PASSWORD': password != null ? '<hidden>' : '<not set>',
        'PB_TOKEN': token ?? '<not set>',
      },
    );

    return state.copyWith.env(
      pbHost: result.host,
      pbUsername: result.usernameOrEmail,
      pbPassword: result.password,
      pbToken: result.token,
    );
  }
}
