import 'package:cli_utils/cli_utils.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../failure/failure.dart';

/// Service for fetching and managing collection data from PocketBase.
///
/// Handles batch fetching of records with progress tracking and
/// comprehensive error handling.
class CollectionDataService {
  const CollectionDataService({required Logger logger}) : _logger = logger;

  final Logger _logger;

  /// Fetches all records from a collection in batches.
  ///
  /// Validates batch size (1-500) and provides progress updates.
  /// Returns all records or a [Failure] if an error occurs.
  ///
  /// Parameters:
  /// - [pb]: Authenticated PocketBase client
  /// - [collectionName]: Name of the collection to fetch
  /// - [batchSize]: Number of records per request (1-500)
  CliFuture<List<RecordModel>> fetchAllRecords({
    required PocketBase pb,
    required String collectionName,
    required int batchSize,
  }) async {

    final styledCollectionName = collectionName.bold;

    final progress = _logger.progress(
      'Fetching records from $styledCollectionName (BS: $batchSize)',
    );

    var offset = 0;
    var totalItems = 0;

    final records = <RecordModel>[];

    while (true) {
      // Get the records batch
      final result = await pb
          .collection(collectionName)
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

      offset += batch.length;
      // Break if we've fetched all items based on totalItems count
      if (records.length >= totalItems) {
        break;
      }

      // 4. Update the progress bar
      final percent = ((records.length / totalItems) * 100).toStringAsFixed(2);
      progress.update(
        'Fetched ${records.length} of $totalItems records ($percent%)...',
      );
    }

    progress.complete(
      'Fetched ${records.length} records from $styledCollectionName.',
    );

    return records.asResult();
  }
}
