import 'dart:convert';

import '../../common.dart';

final class SaveLocalSchemaAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.localSchemaFilePath;

    final view = select.remoteCollections.unlockView;
    final json = const JsonEncoder.withIndent('\t').convert(view);

    file.writeAsString(json);

    return null;
  }
}
