import 'package:freezed_annotation/freezed_annotation.dart';

import ' session/session_state.dart';
import '../utils/path.dart';
import 'config/config_state.dart';
import 'env/env_state.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    required DirectoryPath? workDir,
    required EnvState env,
    required ConfigState config,
    required SessionState session,
  }) = _AppState;

  factory AppState.initial() => const AppState(
    env: EnvState(),
    config: ConfigState(),
    session: SessionUnresolved(),
    workDir: null,
  );
}
