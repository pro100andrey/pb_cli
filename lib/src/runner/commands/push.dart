import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../client/pb_client.dart';
import '../../extensions/string_style.dart';
import '../../failure/common.dart';
import '../../failure/failure.dart';
import '../../models/result.dart';
import '../../utils/path.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import 'context.dart';

class PushCommand extends Command {
  PushCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        S.batchSizeOptionName,
        abbr: S.batchSizeOptionAbbr,
        help: S.pushBatchSizeOptionHelp,
        defaultsTo: S.pushBatchSizeOptionDefault,
      )
      ..addFlag(
        S.truncateFlagName,
        abbr: S.truncateFlagAbbr,
        help: S.truncateFlagHelp,
      );
  }

  @override
  final name = S.pushCommand;

  @override
  final description = S.pushDescription;

  final Logger _logger;

  @override
  Future<int> run() async {
    final dir = DirectoryPath(argResults![S.dirOptionName]);
    // Validate directory path
    if (dir.notFound) {
      return Failure.exIO;
    }

    if (!dir.notFound && !dir.isDirectory) {
      return Failure.exIO;
    }

    final ctxResult = await resolveCommandContext(
      dir: dir,
      logger: _logger,
    );

    if (ctxResult case Result(:final error?)) {
      _logger.err(error.message);
      return error.exitCode;
    }

    final (:inputs, :pbClient, :credentials) = ctxResult.value;

    // final dirArg = argResults!['dir'] as String;
    // final dir = DirectoryPath(dirArg);
    // final storage = Storage(dir);

    // Import the schema
    // await _importPBSchema(config, pb);

    var batchSize = int.tryParse(argResults!['batch-size'] as String) ?? 20;
    if (batchSize <= 0 || batchSize > 50) {
      _logger.warn('Batch size must be between 1 and 50. Using default of 20.');
      batchSize = 20;
    }

    final truncateArg = argResults!['truncate'] as bool;
    if (truncateArg) {
      _logger.detail(
        'Truncate option enabled: Skipping confirmation prompt.',
      );
    }

    final truncate =
        truncateArg ||
        (terminalIsAttached() &&
            _logger.confirm('Truncate collections before seeding?'));

    await _seedCollections(
      pb: pbClient,
      batchSize: batchSize,
      truncate: truncate,
    );

    return ExitCode.success.code;
  }

  /// Imports the PocketBase schema from the specified JSON file into the
  /// connected PocketBase instance.
  Future<void> _importPBSchema(PbClient pb) async {
    // Fetch the current schema from the remote PocketBase instance
    final collectionsResult = await pb.getCollections();

    if (collectionsResult case Result(:final error?)) {
      _logger.err(error.fetchCollectionsSchema);
      return;
    }

    final fromServer = collectionsResult.value;

    const schemaContent = ''; //config.schemaFile.readAsString();
    final collectionsJson = jsonDecode(schemaContent) as List<dynamic>;
    // Convert JSON list to List<CollectionModel>
    final fromJsonFile = collectionsJson
        .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    _logger.info('Comparing local schema with remote schema...');
    const isSame = false;

    if (isSame) {
      _logger.info('Schema is up to date!'.green);
      return;
    }

    // Use the SDK's import method to update the remote schema.
    // Note: By default, this does NOT delete missing collections/fields.
    // To delete missing collections, set `deleteMissing: true` in the import
    // call. await pb.collections.import(collections, deleteMissing: true);
    await pb.importCollections(fromJsonFile);

    _logger.info('Schema imported/updated successfully!'.green);
  }

  Future<void> _seedCollections({
    required PbClient pb,
    // required Config config,
    required int batchSize,
    required bool truncate,
  }) async {
    final emptyMap = <String, bool>{};

    if (!truncate) {}

    if (!truncate && emptyMap.entries.any((e) => !e.value)) {
      _logger.info(
        'Not all collections are empty. Use --truncate option to force '
        'seeding.',
      );
    }
    // config.seedMap.entries
    for (final entry in {'jsonFilePath': 'collectionName'}.entries) {
      final jsonFilePath = entry.key;
      final collectionName = entry.value;

      final shouldProcess = truncate || (emptyMap[entry.value] ?? false);

      if (!shouldProcess) {
        _logger.info(
          'Skipping seeding for ${entry.value} as it is not empty.',
        );
        continue;
      }

      if (truncate) {
        final truncateResult = await pb.truncateCollection(collectionName);

        final shouldContinue = truncateResult.fold(
          (v) => true,
          (error) {
            _logger.err(
              'Failed to truncate $collectionName: $error. Seeding aborted.',
            );
            return false;
          },
        );

        if (!shouldContinue) {
          continue;
        }

        _logger.info('Truncated collection: $collectionName');
      }

      final progress = _logger.progress('Reading $collectionName data...');
      const contents = ''; //jsonFilePath.readAsString();
      // Ensure we are decoding to a List of dynamic maps
      final itemsToSeed = (jsonDecode(contents) as List)
          .cast<Map<String, dynamic>>();

      final totalItems = itemsToSeed.length;
      // This list will accumulate all created records from all batches
      final createdRecords = <BatchResult>[];
      // If total items are less than or equal to batch size, skip progress
      // updates
      final skipProgressUpdate = totalItems <= batchSize;

      for (var i = 0; i < totalItems; i += batchSize) {
        final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
        final batchItems = itemsToSeed.sublist(i, end);
        final batch = pb.instance.createBatch();

        for (final item in batchItems) {
          // Create a mutable copy and remove internal fields
          final itemBody = Map<String, dynamic>.from(item)
            ..remove('collectionId')
            ..remove('collectionName')
            ..remove('created')
            ..remove('updated');

          batch.collection(collectionName).create(body: itemBody);
        }

        // Send the batch and get the results
        final batchResult = await batch.send();

        // Add the records created in this batch to the main list
        createdRecords.addAll(batchResult);

        // Update progress unless skipping
        if (!skipProgressUpdate) {
          final currentTotalCreated = createdRecords.length;
          final percentage = (currentTotalCreated / totalItems * 100).round();
          progress.update(
            'Batch ${i ~/ batchSize + 1}: '
            'Created $currentTotalCreated / $totalItems items ($percentage%).',
          );
        }
      }

      progress.complete(
        'Seeding $collectionName completed. '
        'Created ${createdRecords.length} items.',
      );
    }
  }
}
