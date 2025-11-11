import 'dart:convert';

import '../models/config.dart';
import '../utils/path.dart';

/// An abstract interface for configuration repository operations.
///
/// This interface defines the contract for reading and writing configuration
/// data. Implementations should handle the persistence and retrieval of
/// [Config] objects from their respective storage mechanisms.
///
/// The configuration typically includes:
/// - List of managed collections that the CLI should synchronize
/// - Credentials source preference (dotenv file vs interactive prompts)
/// - User preferences and tool settings
/// - Project-specific configuration options
///
/// Example configuration structure:
/// ```json
/// {
///   "managedCollections": ["users", "posts", "comments"],
///   "credentialsSource": "dotenv"
/// }
/// ```
abstract interface class ConfigRepository {
  /// Reads the configuration data from the storage.
  ///
  /// Returns a [Config] object containing the current configuration settings.
  /// Implementations should handle cases where no configuration exists and
  /// provide appropriate default values or throw meaningful exceptions.
  ///
  /// Example:
  /// ```dart
  /// final config = configRepository.read();
  /// final collections = config.managedCollections;
  /// final source = config.credentialsSource;
  /// ```
  ///
  /// If no configuration file exists, implementations should return a default
  /// or empty configuration rather than throwing an exception.
  ///
  /// Throws an exception if the configuration cannot be read or parsed.
  Config read();

  /// Writes the configuration data to the storage.
  ///
  /// [config] The configuration object to be persisted to storage.
  ///
  /// Implementations should ensure that the configuration is properly
  /// serialized and stored in a way that can be later retrieved by
  /// [read]. The storage format should be human-readable when possible.
  ///
  /// Example:
  /// ```dart
  /// final config = Config.empty().copyWith(
  ///   managedCollections: ['users', 'posts'],
  ///   credentialsSource: CredentialsSource.dotenv,
  /// );
  /// configRepository.write(config);
  /// ```
  ///
  /// Throws an exception if the configuration cannot be written to storage.
  void write(Config config);
}

/// File-based implementation of configuration repository.
///
/// This class manages CLI configuration by storing it as a JSON file
/// in a specified data directory. The configuration is serialized to
/// a human-readable JSON format with proper indentation.
///
/// Features:
/// - JSON format for easy manual editing
/// - Automatic creation of missing configuration files
/// - Type-safe configuration handling through the Config model
/// - Preserves formatting with proper indentation
///
/// File format example:
/// ```json
/// {
///   "managedCollections": [
///     "users",
///     "posts",
///     "comments"
///   ],
///   "credentialsSource": "dotenv"
/// }
/// ```
///
/// Example usage:
/// ```dart
/// final dataDir = DirectoryPath('./pb_data');
/// final configRepo = FileConfigRepository(dataDir);
/// // Read existing configuration
/// final config = configRepo.readConfig();
/// // Update configuration
/// final updatedConfig = config.copyWith(
///   managedCollections: ['users', 'posts', 'new_collection'],
/// );
/// configRepo.writeConfig(updatedConfig);
/// ```
final class FileConfigRepository implements ConfigRepository {
  /// Creates a new file-based configuration repository.
  ///
  /// [_dataDir] The directory where configuration files will be stored.
  /// The directory doesn't need to exist when creating the repository,
  /// but it should be created before writing configuration data.
  const FileConfigRepository(this._dataDir);

  /// The data directory where configuration files are stored.
  final DirectoryPath _dataDir;

  /// The filename used for storing configuration data.
  ///
  /// This is a JSON file that contains all CLI configuration settings
  /// in a human-readable format.
  static const file = 'config.json';

  /// Gets the path to the configuration file.
  ///
  /// Returns a [FilePath] object representing the full path to the
  /// configuration JSON file within the data directory.
  FilePath get _configFile => _dataDir.joinFile(file);

  @override
  Config read() {
    if (_configFile.notFound) {
      return Config.empty();
    }

    final contents = _configFile.readAsString();
    final configMap = jsonDecode(contents);

    return Config(configMap);
  }

  @override
  void write(Config config) {
    final json = const JsonEncoder.withIndent('  ').convert(config.data);

    _configFile.writeAsString(json);
  }
}
