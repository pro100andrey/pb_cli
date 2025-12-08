import '../../common.dart';
import '../../services/schema_sync.dart';

final class CompareSchemaWithRemoteAction extends AppAction {
  @override
  AppState? reduce() {
    final comparator = SchemaSyncService(logger: logger);

    final isSame = comparator.syncSchema(
      localCollections: select.localCollections,
      remoteCollections: select.remoteCollections,
    );

    logger.info(
      !isSame
          ? 'Local schema differs from remote PocketBase schema.'
          : 'Local schema is the same as remote PocketBase schema.',
    );

    return null;
  }
}
