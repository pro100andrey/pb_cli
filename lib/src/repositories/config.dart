import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';

import '../redux/models/config.dart';

abstract interface class ConfigRepository {
  factory ConfigRepository() => const _FileConfigRepositoryImpl();

  Config read({required DirectoryPath dataDir});

  void write({required Config config, required DirectoryPath dataDir});
}

final class _FileConfigRepositoryImpl implements ConfigRepository {
  const _FileConfigRepositoryImpl();

  static const file = 'config.json';

  FilePath _file(DirectoryPath dataDir) => dataDir.joinFile(file);

  @override
  Config read({required DirectoryPath dataDir}) {
    if (_file(dataDir).notFound) {
      return const Config.empty();
    }

    final contents = _file(dataDir).readAsString();
    final configMap = jsonDecode(contents);

    return Config.data(configMap);
  }

  @override
  void write({required Config config, required DirectoryPath dataDir}) {
    final file = _file(dataDir);
    final json = const JsonEncoder.withIndent('  ').convert(config.data);

    file.writeAsString(json);
  }
}
