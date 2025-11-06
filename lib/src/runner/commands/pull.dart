import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

class PullCommand extends Command {
  PullCommand({required Logger logger}) : _logger = logger {
    argParser.addOption(
      'batch-size',
      abbr: 'b',
      help: 'Number of records to fetch per batch. Maximum is 500.',
      defaultsTo: '100',
    );
  }

  @override
  final name = 'pull';

  @override
  final description =
      'Pulls the remote PocketBase schema and collection data into local JSON '
      'files.';

  final Logger _logger;

  @override
  Future<int> run() async => ExitCode.success.code;
}
