import '../../common.dart';
import '../../services/local_schema_service.dart';

final class SaveLocalSchemaAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.workDirPath!.joinFile(LocalSchemaService.fileName);

    LocalSchemaService.write(
      outputFile: file,
      collections: select.remoteCollections,
    );

    return null;
  }
}
