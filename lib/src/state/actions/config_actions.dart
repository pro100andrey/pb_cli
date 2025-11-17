import 'dart:convert';

import '../../models/config.dart';
import '../../models/credentials_source.dart';
import 'action.dart';

const String _fileName = 'config.json';

class LoadConfigAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.workDir.joinFile(_fileName);
    if (file.notFound) {
      return null;
    }

    final contents = file.readAsString();
    final configMap = jsonDecode(contents);
    final config = Config.data(configMap);

    return state.copyWith.config(
      credentialsSource: config.credentialsSource,
      managedCollections: config.managedCollections,
    );
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

    final file = select.workDir.joinFile(_fileName);
    final config = Config.data(data);
    final json = const JsonEncoder.withIndent('  ').convert(data);

    file.writeAsString(json);

    return state.copyWith.config(
      managedCollections: config.managedCollections,
      credentialsSource: config.credentialsSource,
    );
  }
}
