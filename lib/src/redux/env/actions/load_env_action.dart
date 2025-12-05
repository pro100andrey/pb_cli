import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../services/env_service.dart';
import '../../types/env.dart';

class LoadEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDirPath!.joinFile(EnvService.fileName);
    final data = EnvService.read(inputFile: file);

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
