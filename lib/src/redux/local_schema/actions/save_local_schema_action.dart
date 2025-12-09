import '../../common.dart';
import '../local_schema_persistence.dart';

final class SaveLocalSchemaAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.localSchemaFilePath;

    writeLocalSchema(
      outputFile: file,
      collections: select.remoteCollections,
    );

    return null;
  }
}
