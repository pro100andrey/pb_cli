import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:pocketbase/pocketbase.dart';

import 'action.dart';

final class StorePocketBaseAction extends AppAction {
  @override
  AppState? reduce() {
    final host = select.session.host!;

    final pocketBase = PocketBase(host);

    // Save PocketBase instance to the store
    store.setProp(pocketBase);
    logger.detail('PocketBase instance stored.');

    return null;
  }
}
