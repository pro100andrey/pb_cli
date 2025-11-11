import '../utils/path.dart';
import 'config.dart';
import 'env.dart';
import 'schema.dart';
import 'seed.dart';

/// A factory class responsible for creating repository instances.
///
/// This factory provides a centralized way to create different types of
/// repositories with a shared data directory configuration. All repositories
/// created by this factory will use the same base directory for their
/// operations, ensuring consistent data storage and organization.
///
/// The factory pattern is used here to:
/// - Centralize repository creation logic
/// - Ensure consistent data directory usage across all repositories
/// - Provide a clean abstraction for dependency injection
/// - Make testing easier by allowing mock repository implementations
/// - Maintain separation of concerns between different data types
///
/// Data directory structure managed by repositories:
/// ```
/// data_directory/
/// ├── config.json          # CLI configuration (ConfigRepository)
/// ├── .env                 # Environment variables (EnvRepository)
/// ├── pb_schema.json       # PocketBase schema (SchemaRepository)
/// └── collections/         # Collection data files
///     ├── users.json
///     ├── posts.json
///     └── ...
/// ```
///
/// Example usage:
/// ```dart
/// final dataDir = DirectoryPath('./pb_data');
/// final repoFactory = RepositoryFactory(dataDir);
///
/// // Create repositories with shared data directory
/// final configRepo = repoFactory.createConfigRepository();
/// final envRepo = repoFactory.createEnvRepository();
/// final schemaRepo = repoFactory.createSchemaRepository();
///
/// // All repositories will store data in './pb_data'
/// final config = configRepo.readConfig();
/// final env = envRepo.readEnv();
/// final schema = schemaRepo.readSchema();
/// ```
final class RepositoryFactory {
  /// Creates a new repository factory with the specified data directory.
  ///
  /// [_dataDir] The base directory path where all repositories will store their
  /// data. This directory serves as the root for all CLI data files and
  /// subdirectories.
  ///
  /// The data directory doesn't need to exist when creating the factory,
  /// but individual repositories may create it as needed when writing data.
  const RepositoryFactory(this._dataDir);

  /// The base directory path used by all repositories created by this factory.
  ///
  /// This directory acts as the single source of truth for data storage
  /// location across all repository implementations.
  final DirectoryPath _dataDir;

  /// Creates a new configuration repository instance.
  ///
  /// Returns a [ConfigRepository] implementation that manages configuration
  /// data stored in files within the factory's data directory.
  ///
  /// The configuration repository handles:
  /// - CLI settings and preferences
  /// - Managed collection lists
  /// - Credential source configuration
  /// - User-defined options
  ///
  /// Example:
  /// ```dart
  /// final configRepo = repositoryFactory.createConfigRepository();
  /// final config = configRepo.readConfig();
  /// final managedCollections = config.managedCollections;
  /// ```
  ConfigRepository createConfigRepository() => FileConfigRepository(_dataDir);

  /// Creates a new schema repository instance.
  ///
  /// Returns a [SchemaRepository] implementation that manages schema
  /// definitions stored in files within the factory's data directory.
  ///
  /// The schema repository handles:
  /// - PocketBase collection definitions
  /// - Field schemas and validation rules
  /// - Index configurations
  /// - Collection permissions and settings
  ///
  /// Example:
  /// ```dart
  /// final schemaRepo = repositoryFactory.createSchemaRepository();
  /// final collections = await pbClient.getCollections();
  /// schemaRepo.writeSchema(collections);
  /// ```
  SchemaRepository createSchemaRepository() => FileSchemaRepository(_dataDir);

  /// Creates a new environment repository instance.
  ///
  /// Returns an [EnvRepository] implementation that manages environment
  /// variables and settings stored in files within the factory's data
  /// directory.
  ///
  /// The environment repository handles:
  /// - PocketBase connection credentials
  /// - Authentication tokens
  /// - Host configuration
  /// - Sensitive configuration data
  ///
  /// Example:
  /// ```dart
  /// final envRepo = repositoryFactory.createEnvRepository();
  /// final dotenv = envRepo.readEnv();
  /// final host = dotenv.pbHost;
  /// final username = dotenv.pbUsername;
  /// ```
  EnvRepository createEnvRepository() => FileEnvRepository(_dataDir);

  /// Creates a new seed repository instance.
  SeedRepository createSeedRepository() => FileSeedRepository(_dataDir);
}
