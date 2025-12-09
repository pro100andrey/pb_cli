import '../../common.dart';
import '../schema_comparator.dart';

final class CompareSchemasAction extends AppAction {
  @override
  AppState? reduce() {
    final local = select.localCollections;
    final remote = select.remoteCollections;

    final isSame = compareSchemas(local: local, remote: remote, logger: logger);

    logger.info(
      !isSame
          ? 'Local schema differs from remote PocketBase schema.'
          : 'Local schema is the same as remote PocketBase schema.',
    );

    return null;
  }
}
