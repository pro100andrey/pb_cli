import 'package:freezed_annotation/freezed_annotation.dart';

import 'config/config_state.dart';
import 'env/env_state.dart';
import 'schema/schema_state.dart';
import 'session/session_state.dart';
import 'work_dir/work_dir_state.dart';

part 'app_state.freezed.dart';

/// The root state of the application.
@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    /// The current working directory.
    required WorkDirState workDir,

    /// The environment state (loaded from .env file).
    required EnvState env,

    /// The configuration state (loaded from config file).
    required ConfigState config,

    /// The session state (active user credentials).
    required SessionState session,

    /// The schema state (PocketBase collections).
    required SchemaState schema,
  }) = _AppState;

  factory AppState.initial() => const AppState(
    env: EnvState(),
    config: ConfigState(),
    session: SessionState(),
    schema: SchemaState(),
    workDir: WorkDirState(),
  );
}
