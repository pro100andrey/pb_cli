import '../../common.dart';
import '../../services/schema_comparator_service.dart';

final class CompareSchemaWithRemoteAction extends AppAction {
  @override
  AppState? reduce() {
    final local = select.localCollections;
    final remote = select.remoteCollections;

    final comparator = SchemaComparatorService(logger: logger);
    final isSame = comparator.compare(local: local, remote: remote);

    logger.info(
      !isSame
          ? 'Local schema differs from remote PocketBase schema.'
          : 'Local schema is the same as remote PocketBase schema.',
    );

    return null;
  }
}
