import '../../common/app_action.dart';
import '../../env/actions/load_env_action.dart';
import '../../env/env_state.dart';
import '../../session/session_state.dart';
import '../../types/session_token.dart';

/// Populates [SessionState] with credentials from [EnvState].
///
/// Takes values from the loaded .env file and merges them with
/// existing session values. Existing session values take precedence
/// over env values (env values are used as fallback).
///
/// This allows for:
/// - Loading defaults from .env
/// - Overriding specific values via user input
/// - Mix of both sources
///
/// Should be called after [LoadEnvAction].
final class PopulateSessionFromEnvAction extends AppAction {
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
