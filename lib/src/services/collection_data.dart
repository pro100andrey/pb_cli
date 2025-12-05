import 'package:cli_utils/cli_utils.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../client/pb_client.dart';
import '../failure/failure.dart';
import '../models/result.dart';

class CollectionDataService {
  const CollectionDataService({required Logger logger}) : _logger = logger;

  final Logger _logger;

  CliFuture<List<RecordModel>> fetchAllRecords({
    required PbClient pbClient,
    required String collectionName,
    required int batchSize,
  }) async {
    if (batchSize <= 0 || batchSize > 500) {
      return Failure(
        message:
            'Invalid batch size: $batchSize. It must be between 1 and 500.',
        exitCode: ExitCode.usage.code,
      ).asResult();
    }

    final styledCollectionName = collectionName.bold;

    final progress = _logger.progress(
      'Fetching records from $styledCollectionName (BS: $batchSize)',
    );

    var offset = 0;
    var totalItems = 0;

    final records = <RecordModel>[];

    while (true) {
      // Get the records batch
      final result = await pbClient.getCollectionRecordsBatch(
        collectionName,
        batchSize,
        offset,
      );

      // Handle potential errors
      if (result case Result(error: final error?)) {
        progress.fail(
          'Failed to fetch records from collection $styledCollectionName: '
          '${error.message}',
        );
        return error.asResult();
      }

      final resultList = result.value;

      // initialize totalItems on the first fetch
      if (offset == 0) {
        totalItems = resultList.totalItems;
      }

      final batch = resultList.items;

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
