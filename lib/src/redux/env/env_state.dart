import 'package:freezed_annotation/freezed_annotation.dart';

import '../session/session_state.dart';
import '../types/env.dart';
import 'actions/load_env_action.dart';
import 'actions/save_env_action.dart';

part 'env_state.freezed.dart';

/// State representing raw data loaded from .env file.
///
/// This is the source of truth for what exists in the .env file on disk.
/// The state stores environment variables as [EnvData], which provides
/// type-safe access to PocketBase credentials.
///
/// The data is populated by [LoadEnvAction] and updated by [SaveEnvAction].
/// Use `PopulateSessionFromEnvAction` to transfer values to [SessionState].
@freezed
abstract class EnvState with _$EnvState {
  const factory EnvState({
    /// Raw key-value pairs loaded from .env file.
    ///
    /// Empty if the file doesn't exist or hasn't been loaded yet.
    @Default(EnvData.empty()) EnvData data,
  }) = _EnvState;

  const EnvState._();
}
