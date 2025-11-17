import '../../actions/action.dart';
import '../../services/env_service.dart';

final class WriteEnvAction extends AppAction {
  WriteEnvAction({
    required this.host,
    required this.usernameOrEmail,
    required this.password,
    required this.token,
  });

  final String host;
  final String usernameOrEmail;
  final String password;
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

    return state.copyWith.env(
      pbHost: host,
      pbUsername: usernameOrEmail,
      pbPassword: password,
      pbToken: token,
    );
  }
}
