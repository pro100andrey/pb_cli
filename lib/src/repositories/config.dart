import 'dart:convert';

import '../models/config.dart';
import '../utils/path.dart';

/// An abstract interface for configuration repository operations.
///
/// This interface defines the contract for reading and writing configuration
/// data. Implementations should handle the persistence and retrieval of
/// [Config] objects from their respective storage mechanisms.
abstract interface class ConfigRepository {
  /// Reads the configuration data from the storage.
  ///
  /// Returns a [Config] object containing the current configuration settings.
  /// Implementations should handle cases where no configuration exists and
  /// provide appropriate default values or throw meaningful exceptions.
  ///
  /// Throws an exception if the configuration cannot be read or parsed.
  Config readConfig();

  /// Writes the configuration data to the storage.
  ///
  /// [config] The configuration object to be persisted to storage.
  ///
  /// Implementations should ensure that the configuration is properly
  /// serialized and stored in a way that can be later retrieved by
  /// [readConfig].
  ///
  /// Throws an exception if the configuration cannot be written to storage.
  void writeConfig(Config config);
}

final class FileConfigRepository implements ConfigRepository {
  const FileConfigRepository(this._dataDir);

  final DirectoryPath _dataDir;

  static const file = 'config.json';

  FilePath get _configFile => _dataDir.joinFile(file);

  @override
  Config readConfig() {
    if (_configFile.notFound) {
      return Config.empty();
    }

    final contents = _configFile.readAsString();
    final configMap = jsonDecode(contents);

    return Config(configMap);
  }

  @override
  void writeConfig(Config config) {
    final json = const JsonEncoder.withIndent('  ').convert(config.data);

    _configFile.writeAsString(json);
  }
}
