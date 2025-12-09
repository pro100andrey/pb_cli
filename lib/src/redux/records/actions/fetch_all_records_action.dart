import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

/// Action to fetch all records from managed collections in PocketBase.
///
/// Fetches records in batches with progress tracking for each collection.
/// Updates state with fetched records upon completion.
///
/// Parameters:
/// - [batchSize]: Number of records per request (must be 1-500)
final class FetchAllRecordsAction extends AppAction {
  FetchAllRecordsAction({
    required this.batchSize,
  });

  final int batchSize;

  @override
  Future<AppState?> reduce() async {
    final managedCollections = select.managedCollections;

    for (final collection in managedCollections) {
      final records = await _fetchCollectionRecords(collection);

      _updateStateWithRecords(collection, records.lock);
    }

    return null;
  }

  /// Fetches all records from a specific collection using pagination.
  ///
  /// Retrieves records in batches of [batchSize] and tracks progress.
  /// Continues fetching until all records are retrieved.
  ///
  /// Parameters:
  /// - [collection]: Name of the collection to fetch records from
  ///
  /// Returns a list of all fetched [RecordModel] instances.
  Future<List<RecordModel>> _fetchCollectionRecords(String collection) async {
    final progress = logger.progress(
      'Fetching records from $collection (BS: $batchSize)',
    );

    const offset = 0;
    var totalItems = 0;

    final records = <RecordModel>[];

    while (true) {
      final page = (offset ~/ batchSize) + 1;
      // Get the records batch
      final result = await pb
          .collection(collection)
          .getList(perPage: batchSize, page: page);

      // initialize totalItems on the first fetch
      if (offset == 0) {
        totalItems = result.totalItems;
      }

      final items = result.items;

      // Break the loop if no more records are returned
      if (items.isEmpty) {
        break;
      }

      records.addAll(items);

      // Break if we've fetched all items based on totalItems count
      if (records.length >= totalItems) {
        break;
      }

      _updateProgress(progress, records.length, totalItems);
    }

    progress.complete('Fetched ${records.length} records from $collection.');

    return records;
  }

  /// Updates the progress indicator with current fetch statistics.
  ///
  /// Calculates and displays the percentage of records fetched.
  ///
  /// Parameters:
  /// - [progress]: Progress indicator to update
  /// - [fetched]: Number of records fetched so far
  /// - [total]: Total number of records to fetch
  void _updateProgress(Progress progress, int fetched, int total) {
    final percent = (fetched / total * 100).toStringAsFixed(2);
    progress.update('Fetched $fetched of $total records ($percent%)...');
  }

  /// Updates the application state with fetched records.
  ///
  /// Dispatches a synchronous action to add the records to the state
  /// under the specified collection name.
  ///
  /// Parameters:
  /// - [collection]: Collection name to associate with the records
  /// - [records]: Immutable list of fetched records
  void _updateStateWithRecords(String collection, IList<RecordModel> records) =>
      dispatchSync(
        UpdateStateAction.withReducer(
          (state) {
            final table = select.recordsByCollectionName;
            final updated = table.add(collection, records);

            return state.copyWith.records(byCollectionName: updated);
          },
        ),
      );
}
