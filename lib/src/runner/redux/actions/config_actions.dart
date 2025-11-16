import 'dart:convert';

import '../../../models/config.dart';
import '../../../models/credentials_source.dart';
import 'action.dart';

const String _fileName = 'config.json';

class LoadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.dataDir.joinFile(_fileName);
    if (file.notFound) {
      return state.copyWith(config: const Config.empty());
    }

    final contents = file.readAsString();
    final configMap = jsonDecode(contents);
    final config = Config.data(configMap);

    return state.copyWith(config: config);
  }
}

class SaveConfigAction extends AppAction {
  SaveConfigAction({
    required this.managedCollections,
    required this.credentialsSource,
  });

  final List<String>? managedCollections;
  final CredentialsSource? credentialsSource;

  @override
  AppState reduce() {
    final data = {
      ConfigKey.managedCollections: managedCollections,
      ConfigKey.credentialsSource: credentialsSource?.key,
    };

    final file = select.dataDir.joinFile(_fileName);
    final config = Config.data(data);
    final json = const JsonEncoder.withIndent('  ').convert(config.data);

    file.writeAsString(json);

    return state.copyWith(config: config);
  }
}
