import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

final class LoadLocalSchemaAction extends AppAction {
  @override
  AppState? reduce() {
    final file = select.localSchemaFilePath;

    if (file.notFound) {
      return null;
    }

    final contents = file.readAsString();
    final schemaData = jsonDecode(contents) as List;

    final collections = schemaData.map(
      (e) => CollectionModel.fromJson(e as Map<String, dynamic>),
    );

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
