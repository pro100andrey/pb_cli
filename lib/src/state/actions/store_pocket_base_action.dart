import 'package:pocketbase/pocketbase.dart';

import 'action.dart';

final class StorePocketBaseAction extends AppAction {
  @override
  AppState? reduce() {

    


    final pocketBase = PocketBase(select.host!);

    // Save PocketBase instance to the store
    store.setProp(pocketBase);
    logger.detail('PocketBase instance stored.');



    return null;
  }
}
