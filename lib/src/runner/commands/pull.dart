import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../extensions/string_style.dart';
import '../../models/result.dart';
import '../../repositories/config.dart';
import '../../repositories/schema.dart';
import '../../repositories/seed.dart';
import '../../services/schema_sync.dart';
import '../../utils/path.dart';
import '../../utils/strings.dart';
import '../../utils/validation.dart';
import 'context.dart';

class PullCommand extends Command {
  PullCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        S.dirOptionName,
        abbr: S.dirOptionAbbr,
        help: S.dirOptionHelp,
        mandatory: true,
      )
      ..addOption(
        S.batchSizeOptionName,
        abbr: S.batchSizeOptionAbbr,
        help: S.pullBatchSizeOptionHelp,
        defaultsTo: S.pullBatchSizeOptionDefault,
      );
  }

  @override
  final name = S.pullCommand;

  @override
  final description = S.pullDescription;

  final Logger _logger;

  @override
  Future<int> run() async {
    final dir = DirectoryPath(argResults![S.dirOptionName]);
    // 1. Validate directory path
    if (dir.validate() case final failure?) {
      _logger.err(failure.message);
      return failure.exitCode;
    }

    // 2. Resolve command context
    final ctxResult = await resolveCommandContext(dir: dir, logger: _logger);
    if (ctxResult case Result(:final error?)) {
      _logger.err(error.message);
      return error.exitCode;
    }

    final (
      :inputs,
      :pbClient,
      :credentials,
    ) = ctxResult.value;

    // 3. Sync collections schema from PocketBase server
    final progress = _logger.progress('Fetching collections schema');
    final collectionsResult = await pbClient.getCollections();
    if (collectionsResult case Result(:final error?)) {
      progress.fail(error.message);
      return error.exitCode;
    }

    final remoteCollections = collectionsResult.value;
    progress.complete('Fetched ${remoteCollections.length} collections schema');

    final schemaRepository = SchemaRepository();
    final localCollections = schemaRepository.read(dataDir: dir);
    final schemaService = SchemaSyncService(logger: _logger);

    final isSame = await schemaService.syncSchema(
      remoteCollections: remoteCollections,
      localCollections: localCollections,
    );

    if (isSame) {
      _logger.info('Schema file is already up-to-date.');
    }

    // Always overwrite local schema with the latest from server
    schemaRepository.write(collections: remoteCollections, dataDir: dir);

    //4. Sync managed collections data (records, files)
    final configRepository = ConfigRepository();
    final config = configRepository.read(dataDir: dir);
    final seedRepository = SeedRepository();

    final batchSize = int.parse(argResults![S.batchSizeOptionName] as String);

    for (final collectionName in config.managedCollections) {
      final records = <RecordModel>[];

      final result = await pbClient.getCollectionRecordsBatch(
        collectionName,
        batchSize,
        0,
      );

      if (result case Result(:final error?)) {
        _logger.err(
          'Failed to fetch records for collection '
          '${collectionName.bold.underlined}: ${error.message}',
        );
        return error.exitCode;
      }

      records.addAll(result.value.items);

      _logger.info(
        'Fetched ${records.length} records from collection '
        '${collectionName.bold.underlined}',
      );

      seedRepository.write(
        records: records,
        collectionName: collectionName,
        dataDir: dir,
      );
    }

    return ExitCode.success.code;
  }
}
