import '../../actions/action.dart';

final class FetchSchemaAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final collections = await pb.collections.getFullList();

    return state.copyWith.schema(collections: collections);
  }
}
