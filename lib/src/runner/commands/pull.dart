import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../extensions/string_style.dart';
import '../../models/result.dart';
import '../../utils/path.dart';
import '../../utils/schema_checker.dart';
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
    // Validate directory path
    if (dir.validate() case final failure?) {
      _logger.err(failure.message);
      return failure.exitCode;
    }

    final ctxResult = await resolveCommandContext(dir: dir, logger: _logger);
    if (ctxResult case Result(:final error?)) {
      _logger.err(error.message);
      return error.exitCode;
    }

    final (
      :repositories,
      :inputs,
      :pbClient,
      :credentials,
    ) = ctxResult.value;

    // final configRepository = repositories.createConfigRepository();
    // final config = configRepository.readConfig();

    final collectionsResult = await pbClient.getCollections();
    if (collectionsResult case Result(:final error?)) {
      _logger.err(error.message);
      return error.exitCode;
    }

    final collections = collectionsResult.value;
    final schemaRepository = repositories.createSchemaRepository();
    final localCollections = schemaRepository.readSchema();

    final isSame = checkPBSchema(collections, localCollections, _logger);

    if (!isSame) {
      schemaRepository.writeSchema(collections);
      _logger.info('Schema updated in directory: ${dir.path.bold.underlined}');
    }

    return ExitCode.success.code;
  }
}
