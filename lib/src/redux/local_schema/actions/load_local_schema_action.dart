import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';
import '../../services/local_schema_service.dart';

final class LoadLocalSchemaAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.workDirPath!.joinFile(LocalSchemaService.fileName);
    final collections = LocalSchemaService.read(inputFile: file);

    final byId = <String, CollectionModel>{};
    final ids = <String>[];

    for (final collection in collections) {
      byId[collection.id] = collection;
      ids.add(collection.id);
    }

    return state.copyWith.localSchema(
      byId: byId.toIMap(),
      sorted: ids.toIList(),
    );
  }
}
