import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

/// Action to fetch all records from managed collections in PocketBase.
/// Utilizes batch fetching with progress tracking.
///
/// Parameters:
/// - [batchSize]: Number of records to fetch per request (1-500)
///
/// Returns updated [AppState] with fetched records.
final class FetchAllRecordsAction extends AppAction {
  FetchAllRecordsAction({
    required this.batchSize,
  });

  final int batchSize;

  @override
  Future<AppState?> reduce() async {
    final managedCollections = select.managedCollections;

    for (final collection in managedCollections) {
      final progress = logger.progress(
        'Fetching records from $collection (BS: $batchSize)',
      );

      const offset = 0;
      var totalItems = 0;

      final records = <RecordModel>[];

      while (true) {
        // Get the records batch
        final result = await pb
            .collection(collection)
            .getList(perPage: batchSize, page: (offset ~/ batchSize) + 1);

        // initialize totalItems on the first fetch
        if (offset == 0) {
          totalItems = result.totalItems;
        }

        final batch = result.items;

        // Break the loop if no more records are returned
        if (batch.isEmpty) {
          break;
        }

        records.addAll(batch);

        // Break if we've fetched all items based on totalItems count
        if (records.length >= totalItems) {
          break;
        }

        final percent = ((records.length / totalItems) * 100).toStringAsFixed(
          2,
        );

        progress.update(
          'Fetched ${records.length} of $totalItems records ($percent%)...',
        );
      }

      progress.complete(
        'Fetched ${records.length} records from $collection.',
      );
    }
    return null;
  }
}
