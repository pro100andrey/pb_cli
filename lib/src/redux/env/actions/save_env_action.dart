import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../services/env_service.dart';
import '../../types/env.dart';

final class SaveEnvAction extends AppAction {
  @override
  AppState reduce() {
    final data = EnvData.data({
      EnvKey.pbHost: ?select.host,
      EnvKey.pbUsername: ?select.usernameOrEmail,
      EnvKey.pbPassword: ?select.password,
      EnvKey.pbToken: ?select.token,
    });

    final file = select.workDirPath!.joinFile(EnvService.fileName);

    EnvService.write(
      outputFile: file,
      variables: data,
    );

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
