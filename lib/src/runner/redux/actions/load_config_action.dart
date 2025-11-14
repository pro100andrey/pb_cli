import 'dart:convert';

import '../../../models/config.dart';
import 'action.dart';

class LoadConfigAction extends AppAction {
  static const String _fileName = 'config.json';

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

  @override
  String toString() => 'LoadConfigAction(file: $_fileName)';
}
