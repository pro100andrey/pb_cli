import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

final class SetupPocketBaseConnectionAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final pocketBase = PocketBase(select.host!);

    final health = await pocketBase.health.check();
    if (health.code == 200) {
      logger.detail('PocketBase health check passed');
    }

    // Save PocketBase instance to the store
    store.setProp(pocketBase);
    logger.detail('PocketBase instance stored.');

    return null;
  }
}
