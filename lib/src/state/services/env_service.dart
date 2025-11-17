import '../../utils/path.dart';

typedef ReadEnvResult = ({
  String host,
  String usernameOrEmail,
  String password,
  String? token,
});

final class EnvService {

  static const String fileName = '.env';

  void write({
    required FilePath outputFile,
    required String host,
    required String usernameOrEmail,
    required String password,
    required String? token,
  }) {
    final data = <DotenvKey, String>{
      DotenvKey.pbHost: host,
      DotenvKey.pbUsername: usernameOrEmail,
      DotenvKey.pbPassword: password,
      DotenvKey.pbToken: ?token,
    };

    _write(data, outputFile);
  }

  ReadEnvResult? read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return null;
    }

    final envData = _read(file: inputFile);

    if (envData.isEmpty) {
      return null;
    }

    return (
      host: envData[DotenvKey.pbHost]!,
      usernameOrEmail: envData[DotenvKey.pbUsername]!,
      password: envData[DotenvKey.pbPassword]!,
      token: envData[DotenvKey.pbToken],
    );
  }

  void _write(Map<DotenvKey, String> data, FilePath file) {
    // 1. Read existing .env data with merge priority to new data
    final envData = _read(file: file)..addAll(data);
    // 2. Write back to .env file
    final buffer = StringBuffer();
    for (final entry in envData.entries) {
      buffer.writeln('${entry.key}=${entry.value}');
    }
    file.writeAsString(buffer.toString());
  }

  Map<DotenvKey, String> _read({required FilePath file}) {
    final envData = <DotenvKey, String>{};

    if (!file.notFound) {
      final lines = file.readAsLines();
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
}

extension type const DotenvKey._(String value) implements String {
  /// Creates a [DotenvKey] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not a known key.
  factory DotenvKey(String value) {
    if (!_known.contains(value)) {
      throw ArgumentError('Unknown DotenvKey: $value');
    }

    return DotenvKey._(value);
  }

  /// Host key for PocketBase instance.
  static const pbHost = DotenvKey._('PB_HOST');

  /// Username or email key for PocketBase authentication.
  static const pbUsername = DotenvKey._('PB_USERNAME');

  /// Password key for PocketBase authentication.
  static const pbPassword = DotenvKey._('PB_PASSWORD');

  /// Token key for PocketBase authentication.
  static const pbToken = DotenvKey._('PB_TOKEN');

  /// Set of all known [DotenvKey]s.
  static const Set<DotenvKey> _known = {
    pbHost,
    pbUsername,
    pbPassword,
    pbToken,
  };
}
