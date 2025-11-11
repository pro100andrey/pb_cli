import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../client/pb_client.dart';
import '../extensions/string_style.dart';
import '../failure/failure.dart';
import '../models/result.dart';

class CollectionDataService {
  const CollectionDataService({
    required Logger logger,
  }) : _logger = logger;

  final Logger _logger;

  CliFuture<List<RecordModel>> fetchAllRecords({
    required PbClient pbClient,
    required String collectionName,
    required int batchSize,
  }) async {
    final styledCollectionName = collectionName.bold;

    final progress = _logger.progress(
      'Fetching records from $styledCollectionName (Batch Size: $batchSize)',
    );

    var offset = 0;
    var hasMore = true;

    final records = <RecordModel>[];

    while (hasMore) {
      final result = await pbClient.getCollectionRecordsBatch(
        collectionName,
        batchSize,
        offset,
      );

      if (result case Result(error: final error?)) {
        progress.fail(
          'Failed to fetch records from collection $styledCollectionName: '
          '${error.message}',
        );
        return error.asResult();
      }

      final batch = result.value.items;
      records.addAll(batch);

      offset += batch.length;
      hasMore = batch.length == batchSize;

      progress.update('Fetched ${records.length} records...');
    }

    progress.complete(
      'Fetched total of ${records.length} records '
      'from collection $styledCollectionName.',
    );

    return records.asResult();
  }
}
