import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../common/app_action.dart';

final class FetchRemoteSchemaAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final collections = await pb.collections.getFullList();

    logger.detail('Fetched ${collections.length} collections from PocketBase.');

    final byId = IMap.fromValues(values: collections, keyMapper: (c) => c.id);
    return state.copyWith.remoteSchema(byId: byId);
  }
}
