import '../../common/app_action.dart';

final class FetchRemoteSchemaAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final collections = await pb.collections.getFullList();

    logger.detail('Fetched ${collections.length} collections from PocketBase.');

    return state.copyWith.remoteSchema(collections: collections);
  }
}
