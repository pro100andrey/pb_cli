import 'package:freezed_annotation/freezed_annotation.dart';

import '../types/session_token.dart';

part 'session_state.freezed.dart';

/// State representing the active session credentials.
///
/// These credentials are used for the current connection and may come from:
/// - .env file (via LoadEnvAction + PopulateSessionFromEnvAction)
/// - User input (via ResolveCredentialsAction)
/// - Mix of both (env provides defaults, user overrides)
@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState({
    /// PocketBase instance host URL.
    String? host,

    /// Username or email for authentication.
    String? usernameOrEmail,

    /// Password for authentication.
    String? password,

    /// JWT authentication token.
    SessionToken? token,
  }) = _SessionState;
}
