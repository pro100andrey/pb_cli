import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/credentials_source.dart';
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
  }) = _AppState;

  factory AppState.initial() => const AppState(
    env: EnvState(),
    config: ConfigState(),
    workDir: null,
  );
}

/// Extension methods for convenient access to AppState properties.
extension type Selectors(AppState state) {
  DirectoryPath get workDir => state.workDir!;

  // Config get config => state.config;
  List<String> get managedCollections => state.config.managedCollections ?? [];
  CredentialsSource get credentialsSource =>
      state.config.credentialsSource ?? CredentialsSource.prompt;

  String? get pbHost => state.env.pbHost;
  String? get pbUsername => state.env.pbUsername;
  String? get pbPassword => state.env.pbPassword;
  String? get pbToken => state.env.pbToken;

  // bool get useEnv => dotenv.hasData && config.credentialsSource.isDotenv;
}
