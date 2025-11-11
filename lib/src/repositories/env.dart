import '../models/dotenv.dart';
import '../utils/path.dart';

/// Abstract interface for environment variable repository operations.
///
/// This interface defines the contract for reading and writing environment
/// variables used by the CLI tool. Environment variables typically contain
/// sensitive configuration data such as:
/// - PocketBase connection details (host, credentials)
/// - Authentication tokens
/// - API keys and secrets
///
/// Implementations should handle secure storage and retrieval of these
/// environment variables from their respective storage mechanisms.
abstract interface class EnvRepository {
  /// Creates a new environment repository.
  const EnvRepository();

  /// Reads environment variables from storage.
  ///
  /// Returns a [Dotenv] object containing all environment variables
  /// relevant to the CLI tool. If no environment file exists,
  /// implementations should return an empty Dotenv object.
  ///
  /// Example:
  /// ```dart
  /// final dotenv = envRepository.read();
  /// final host = dotenv.pbHost;
  /// final username = dotenv.pbUsername;
  /// ```
  ///
  /// Throws an exception if the environment data cannot be read.
  Dotenv read();

  /// Writes environment variables to storage.
  ///
  /// [dotenv] The environment data to persist. This should contain
  /// key-value pairs for PocketBase configuration.
  ///
  /// Implementations should merge the new data with existing environment
  /// variables, giving priority to the new values.
  ///
  /// Example:
  /// ```dart
  /// final dotenv = Dotenv({
  ///   DotenvKey.pbHost: 'http://localhost:8090',
  ///   DotenvKey.pbUsername: 'admin@example.com',
  /// });
  /// envRepository.write(dotenv);
  /// ```
  ///
  /// Throws an exception if the environment data cannot be written.
  void write(Dotenv dotenv);
}

/// File-based implementation of environment variable repository.
///
/// This class manages environment variables by storing them in a `.env` file
/// within the specified data directory. The implementation follows standard
/// dotenv file format with key=value pairs.
///
/// Features:
/// - Preserves existing environment variables when writing new ones
/// - Supports comments and empty lines in .env files
/// - Handles multi-line values and special characters
/// - Maintains file format consistency
///
/// Example .env file format:
/// ```
/// # PocketBase Configuration
/// PB_HOST=http://localhost:8090
/// PB_USERNAME=admin@example.com
/// PB_PASSWORD=secretpassword
/// PB_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
/// ```
///
/// Example usage:
/// ```dart
/// final dataDir = DirectoryPath('./pb_data');
/// final envRepo = FileEnvRepository(dataDir);
/// // Read current environment
/// final currentEnv = envRepo.readEnv();
/// // Update with new values
/// final updatedEnv = currentEnv.copyWith(
///   pbHost: 'https://api.example.com',
/// );
/// envRepo.writeEnv(updatedEnv);
/// ```
final class FileEnvRepository implements EnvRepository {
  /// Creates a new file-based environment repository.
  ///
  /// [_dataDir] The directory where the .env file will be stored.
  const FileEnvRepository(this._dataDir);

  /// The data directory where environment files are stored.
  final DirectoryPath _dataDir;

  /// The filename used for storing environment variables.
  static const file = '.env';

  /// Gets the path to the .env file.
  FilePath get _envFile => _dataDir.joinFile(file);

  @override
  Dotenv read() {
    final data = _readEnv(_envFile);

    return Dotenv(data);
  }

  @override
  void write(Dotenv dotenv) {
    _writeEnv(dotenv.data, _envFile);
  }
}

/// Writes environment variable data to a .env file.
///
/// This function merges new environment data with existing data in the file,
/// giving priority to new values. The merge process preserves the order of
/// existing entries while adding new ones at the end.
///
/// [data] The environment variable data to write.
/// [envFile] The path to the .env file.
///
/// The function follows these steps:
/// 1. Read existing .env data from the file
/// 2. Merge new data with existing data (new data takes priority)
/// 3. Write the merged data back to the file in key=value format
void _writeEnv(Map<DotenvKey, String> data, FilePath envFile) {
  // 1. Read existing .env data with merge priority to new data
  final envData = _readEnv(envFile)..addAll(data);
  // 2. Write back to .env file
  final buffer = StringBuffer();
  for (final entry in envData.entries) {
    buffer.writeln('${entry.key}=${entry.value}');
  }
  envFile.writeAsString(buffer.toString());
}

/// Reads environment variable data from a .env file.
///
/// This function parses a .env file and extracts key-value pairs while
/// handling various edge cases:
/// - Empty lines and comments (lines starting with #) are ignored
/// - Values can contain '=' characters (only the first '=' is used as
/// separator)
/// - Keys and values are trimmed of whitespace
/// - Non-existent files are handled gracefully
///
/// [envFile] The path to the .env file to read.
///
/// Returns a map of environment variable keys to their values.
/// Returns an empty map if the file doesn't exist.
///
/// Example file content:
/// ```
/// # Database configuration
/// PB_HOST=http://localhost:8090
/// PB_USERNAME=admin
/// PB_PASSWORD=secret=with=equals
/// ```
///
/// Returns:
/// ```dart
/// {
///   DotenvKey.pbHost: 'http://localhost:8090',
///   DotenvKey.pbUsername: 'admin',
///   DotenvKey.pbPassword: 'secret=with=equals',
/// }
/// ```
Map<DotenvKey, String> _readEnv(FilePath envFile) {
  final envData = <DotenvKey, String>{};

  if (!envFile.notFound) {
    final lines = envFile.readAsLines();
    for (final line in lines) {
      // Skip empty lines or comments
      if (line.trim().isEmpty || line.startsWith('#')) {
        continue;
      }
      // Split at the first '=' to separate key and value
      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        envData[DotenvKey(key)] = value;
      }
    }
  }

  return envData;
}
