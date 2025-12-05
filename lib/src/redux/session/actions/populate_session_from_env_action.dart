import '../../common/app_action.dart';
import '../../types/session_token.dart';

class PopulateSessionFromEnvAction extends AppAction {
  @override
  AppState reduce() {
    final envData = state.env.data;
    final session = state.session;

    final host = session.host ?? envData.host;
    final usernameOrEmail = session.usernameOrEmail ?? envData.usernameOrEmail;
    final password = session.password ?? envData.password;
    final token =
        session.token ??
        (envData.token != null ? SessionToken(envData.token!) : null);

    // Use existing session values, fall back to env if not set
    return state.copyWith.session(
      host: host,
      usernameOrEmail: usernameOrEmail,
      password: password,
      token: token,
    );
  }
}
