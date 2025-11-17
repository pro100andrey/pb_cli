import '../../actions/action.dart';
import '../../services/env_service.dart';

class ReadEnvAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(EnvService.fileName);
    final result = EnvService().read(inputFile: file);

    logger.detail(
      'Loaded .env file from: ${file.canonicalized} '
      'hasData=${result != null}',
    );

    return state.copyWith.env(
      pbHost: result?.host,
      pbUsername: result?.usernameOrEmail,
      pbPassword: result?.password,
      pbToken: result?.token,
    );
  }
}
