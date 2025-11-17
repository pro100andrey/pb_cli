import 'package:pocketbase/pocketbase.dart';

import '../ session/session_state.dart';
import 'action.dart';

final class StorePocketBaseAction extends AppAction {
  @override
  AppState? reduce() {
    final host = switch (select.session) {
      SessionToken(:final host) || SessionUser(:final host) => host,
      _ => throw Exception(
        'Cannot store PocketBase instance: session is unresolved.',
      ),
    };

    final pocketBase = PocketBase(host);

    // Save PocketBase instance to the store
    store.setProp(pocketBase);
    logger.detail('PocketBase instance stored.');

    return null;
  }
}
