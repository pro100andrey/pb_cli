import 'package:args/command_runner.dart';
import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/common/app_action.dart';
import '../../redux/config/actions/load_config_action.dart';
import '../../redux/env/actions/load_env_action.dart';
import '../../redux/local_schema/local_schema.dart';
import '../../redux/records/records.dart';
import '../../redux/remote_schema/remote_schema.dart';
import '../../redux/session/session.dart';
import '../../redux/work_dir/work_dir.dart';
import '../../utils/strings.dart';
import 'base_command.dart';

class PullCommand extends Command with WithStore {
  PullCommand({required this.store}) {
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

  @override
  final Store<AppState> store;

  @override
  Future<int> run() async {
    logger.info('Starting pull command...');

    // 1. Resolve working directory
    final path = argResults![S.dirOptionName];
    dispatchSync(ResolveWorkDirAction(path: path, context: .pull));

    // 2. Load existing config and env files
    dispatchSync(LoadConfigAction());
    dispatchSync(LoadEnvAction());

    // 3. Populate session from env (use existing values if available)
    dispatchSync(PopulateSessionFromEnvAction());

    // 4. Resolve missing credentials from user (only if needed)
    dispatchSync(ResolveCredentialsAction());
    dispatchSync(ValidateCredentialsAction());

    // 5. Setup PocketBase connection and authenticate
    await dispatchAndWait(SetupPocketBaseConnectionAction());
    await dispatchAndWait(LogInAction());

    // 6. Fetch remote schema
    await dispatchAndWait(FetchRemoteSchemaAction());
    dispatchSync(LoadLocalSchemaAction());
    dispatchSync(CompareSchemasAction());
    dispatchSync(SaveLocalSchemaAction());

    final batchSize =
        int.tryParse(argResults![S.batchSizeOptionName]) ??
        int.parse(S.pullBatchSizeOptionDefault);

    await dispatchAndWait(FetchAllRecordsAction(batchSize: batchSize));
    dispatchSync(SaveRecordsAction());
    await dispatchAndWait(DownloadFilesAction());

    // for (final collectionName in config.managedCollections) {
    //   final recordsResult = await _collectionDataService.fetchAllRecords(
    //     pbClient: pbClient,
    //     collectionName: collectionName,
    //     batchSize: batchSize,
    //   );

    //   if (recordsResult case Result(:final error?)) {
    //     logger.err(error.message);
    //     return error.exitCode;
    //   }

    //   final records = recordsResult.value;

    //   _seederRepository.write(
    //     collectionName: collectionName,
    //     records: records,
    //     dataDir: dir,
    //   );

    //   final remoteCollection = remoteCollections.firstWhere(
    //     (c) => c.name == collectionName,
    //   );

    //   // Download files for this collection
    //   await _filesDownloaderService.downloadCollectionFiles(
    //     pbClient: pbClient,
    //     collection: remoteCollection,
    //     records: records,
    //     baseDir: dir,
    //   );

    //   logger.info(
    //     'Seed data for collection $collectionName updated '
    //     '(${records.length} records).',
    //   );
    // }

    return ExitCode.success.code;
  }
}
