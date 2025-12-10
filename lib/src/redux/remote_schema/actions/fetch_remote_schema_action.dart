import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common/app_action.dart';

/// Action to fetch the collection schema from the remote PocketBase server.
///
/// Loads all collections and organizes them into three data structures:
/// - `byId`: Map for fast access by ID
/// - `sorted`: Complete list of collection IDs
/// - `sortedWithoutSystem`: List of IDs excluding system collections
///
/// Optimized for minimal data passes (O(n) complexity).
final class FetchRemoteSchemaAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    final progress = logger.progress('Fetching remote schema...');

    final collections = await pb.collections.getFullList();

    progress.complete(
      'Fetched ${collections.length} collections from PocketBase.',
    );

    final byId = <String, CollectionModel>{};
    final ids = <String>[];
    final sortedWithoutSystem = <String>[];

    for (final collection in collections) {
      byId[collection.id] = collection;
      ids.add(collection.id);

      if (!collection.system) {
        sortedWithoutSystem.add(collection.id);
      }
    }

    return state.copyWith.remoteSchema(
      byId: byId.toIMap(),
      sorted: ids.toIList(),
      sortedWithoutSystem: sortedWithoutSystem.toIList(),
    );
  }
}
