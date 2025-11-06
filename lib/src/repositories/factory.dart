import '../utils/path.dart';
import 'config.dart';
import 'env.dart';

import 'schema.dart';

/// A factory class responsible for creating repository instances.
///
/// This factory provides a centralized way to create different types of
/// repositories with a shared data directory configuration. All repositories
/// created by this factory will use the same base directory for their
/// operations.
final class RepositoryFactory {
  /// Creates a new repository factory with the specified data directory.
  ///
  /// [_dataDir] The base directory path where all repositories will store their
  /// data.
  const RepositoryFactory(this._dataDir);

  /// The base directory path used by all repositories created by this factory.
  final DirectoryPath _dataDir;

  /// Creates a new configuration repository instance.
  ///
  /// Returns a [ConfigRepository] implementation that manages configuration
  /// data stored in files within the factory's data directory.
  ConfigRepository createConfigRepository() => FileConfigRepository(_dataDir);

  /// Creates a new schema repository instance.
  ///
  /// Returns a [SchemaRepository] implementation that manages schema
  /// definitions stored in files within the factory's data directory.
  SchemaRepository createSchemaRepository() => FileSchemaRepository(_dataDir);

  /// Creates a new environment repository instance.
  ///
  /// Returns an [EnvRepository] implementation that manages environment
  /// variables and settings stored in files within the factory's data
  /// directory.
  EnvRepository createEnvRepository() => FileEnvRepository(_dataDir);
}
