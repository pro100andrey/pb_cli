import 'package:pocketbase/pocketbase.dart';

import 'action.dart';

final class StorePocketBaseAction extends AppAction {
  @override
  AppState? reduce() {
    final host = select.pbHost!;
    final pocketBase = PocketBase(host);

    // Save PocketBase instance to the store
    store.setProp(pocketBase);
    logger.detail('PocketBase instance stored.');

    if (select.hasToken && select.tokenIsValid) {
      pocketBase.authStore.save(select.pbToken!, null);
      logger.detail('Using existing authentication token.');
    } else {
      logger.detail('No valid authentication token found.');
    }

    return null;
  }
}
