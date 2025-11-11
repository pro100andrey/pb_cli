import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../models/result.dart';
import '../../repositories/config.dart';
import '../../repositories/schema.dart';
import '../../repositories/seed.dart';
import '../../services/collection_data.dart';
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
  final _schemaRepository = SchemaRepository();
  final _configRepository = ConfigRepository();
  final _seederRepository = SeedRepository();
  late final _schemaSyncService = SchemaSyncService(logger: _logger);
  late final _collectionDataService = CollectionDataService(logger: _logger);

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
    final fetchProgress = _logger.progress('Fetching schema from server');
    final collectionsResult = await pbClient.getCollections();
    if (collectionsResult case Result(:final error?)) {
      fetchProgress.fail(error.message);
      return error.exitCode;
    }

    fetchProgress.complete('Fetched schema from server successfully.');

    final syncProgress = _logger.progress('Syncing collections schema');

    final remoteCollections = collectionsResult.value;
    final localCollections = _schemaRepository.read(dataDir: dir);
    final isSame = await _schemaSyncService.syncSchema(
      remoteCollections: remoteCollections,
      localCollections: localCollections,
    );

    // Always overwrite local schema with the latest from server
    _schemaRepository.write(collections: remoteCollections, dataDir: dir);

    syncProgress.complete(
      isSame
          ? 'Collections schema is already up to date.'
          : 'Collections schema synced successfully.',
    );

    final config = _configRepository.read(dataDir: dir);
    final batchSize = int.parse(argResults![S.batchSizeOptionName] as String);

    for (final collectionName in config.managedCollections) {
      final records = await _collectionDataService.fetchAllRecords(
        pbClient: pbClient,
        collectionName: collectionName,
        batchSize: batchSize,
      );

      if (records case Result(:final error?)) {
        _logger.err(error.message);
        return error.exitCode;
      }

      _seederRepository.write(
        collectionName: collectionName,
        records: records.value,
        dataDir: dir,
      );
    }

    return ExitCode.success.code;
  }
}
