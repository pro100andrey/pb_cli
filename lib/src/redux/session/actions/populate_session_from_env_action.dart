import '../../action.dart';

class PopulateSessionFromEnvAction extends AppAction {
  @override
  AppState reduce() {
    final env = state.env;
    final session = state.session;

    return state.copyWith.session(
      host: session.host ?? env.host,
      usernameOrEmail: session.usernameOrEmail ?? env.usernameOrEmail,
      password: session.password ?? env.password,
      token: session.token ?? env.token,
    );
  }
}
