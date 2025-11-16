import '../../models/config.dart';
import '../../models/dotenv.dart';
import '../../utils/path.dart';

/// Represents the overall state of the application.
class AppState {
  const AppState._({
    required this.dataDir,
    required this.dotenv,
    required this.config,
  });

  /// Creates the initial application state with default values.
  AppState.initial()
    : dataDir = DirectoryPath.current(),
      dotenv = const Dotenv.empty(),
      config = const Config.empty();

  /// The directory where application data is stored.
  final DirectoryPath dataDir;

  /// The environment variables loaded from a .env file.
  final Dotenv dotenv;

  /// The application configuration settings.
  final Config config;

  /// Creates a copy of the current state with optional new values.
  AppState copyWith({
    DirectoryPath? dataDir,
    Dotenv? dotenv,
    Config? config,
  }) => AppState._(
    dataDir: dataDir ?? this.dataDir,
    dotenv: dotenv ?? this.dotenv,
    config: config ?? this.config,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          other.dataDir == dataDir &&
          other.dotenv == dotenv &&
          other.config == config;

  @override
  int get hashCode => Object.hash(
    dataDir,
    dotenv,
    config,
  );
}

/// Extension methods for convenient access to AppState properties.
extension type Selectors(AppState state) {
  DirectoryPath get dataDir => state.dataDir;

  Dotenv get dotenv => state.dotenv;

  Config get config => state.config;

  bool get useEnv => dotenv.isComplete && config.credentialsSource.isDotenv;
}
