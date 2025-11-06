import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../utils/strings.dart';
import 'commands/pull.dart';
import 'commands/push.dart';
import 'commands/setup.dart';

Future<int> run(List<String> args) async {
  final logger = Logger();

  try {
    final runner = CommandRunner(S.appName, S.appDescription)
      ..argParser.addFlag(
        S.verboseFlagName,
        abbr: S.verboseFlagAbbr,
        help: S.verboseFlagHelp,
        negatable: false,
        callback: (value) => logger.level = value ? Level.verbose : Level.info,
      )
      ..addCommand(SetupCommand(logger: logger))
      ..addCommand(PushCommand(logger: logger))
      ..addCommand(PullCommand(logger: logger));
    final runResult = await runner.run(args);

    if (runResult case int()) {
      return runResult;
    }

    return 0;
  } on Object catch (e) {
    final exception = e;

    if (e case UsageException() || ArgumentError()) {
      logger
        ..err(exception.toString())
        ..err('Rerun with --help for usage information.');
      return 64; // Exit code 64 indicates a usage error.
    }

    rethrow;
  }
}
