import 'package:freezed_annotation/freezed_annotation.dart';

import 'config/config_state.dart';
import 'env/env_state.dart';
import 'local_schema/local_schema_state.dart';
import 'records/records_state.dart';
import 'remote_schema/remote_schema_state.dart';
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

    /// The remote schema state (PocketBase collections).
    required RemoteSchemaState remoteSchema,

    /// The local schema state (local collection definitions).
    required LocalSchemaState localSchema,

    required RecordsState records,
  }) = _AppState;

  factory AppState.initial() => const AppState(
    workDir: UnresolvedWorkDir(),
    env: EnvState(),
    config: ConfigState(),
    session: SessionState(),
    remoteSchema: RemoteSchemaState(),
    localSchema: LocalSchemaState(),
    records: RecordsState(),
  );
}
