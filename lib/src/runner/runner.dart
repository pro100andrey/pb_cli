import 'package:args/command_runner.dart';
import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../redux/common/app_action.dart';
import '../redux/guards/wrap_reduce.dart';
import '../redux/observers/action_observer.dart';
import '../redux/observers/error_observer.dart';
import '../redux/observers/global_wrap_error.dart';
import 'commands/pull.dart';
import 'commands/push.dart';
import 'commands/setup.dart';

Future<int> run(List<String> args) async {
  final logger = Logger();

  try {
    // Initialize the Redux store
    final store = Store<AppState>(
      initialState: AppState.initial(),
      actionObservers: [AppActionLogger(logger: logger)],
      errorObserver: AppErrorObserver(logger: logger),
      globalWrapError: AppGlobalWrapError(),
      wrapReduce: GuardsWrapReduce(),
    );

    // Setup the command runner
    final runner =
        CommandRunner(
            'pb_cli',
            'A utility for synchronizing PocketBase schemas and data.',
          )
          ..argParser.addFlag(
            'verbose',
            abbr: 'v',
            help: 'Enable verbose logging output.',
            negatable: false,
            callback: (value) =>
                logger.level = value ? Level.verbose : Level.info,
          )
          ..addCommand(SetupCommand(store: store))
          ..addCommand(PushCommand(store: store))
          ..addCommand(PullCommand(store: store));

    // Parse and run the command
    final result = runner.parse(args);

    // Store the logger in the Redux store for global access
    store.setProp(logger);
    logger.detail('Logger instance stored.');

    // Run the command
    final runResult = await Future.sync(() => runner.runCommand(result));

    if (runResult case int()) {
      return runResult;
    }

    return 0;
  } on Object catch (e) {
    final exception = e;

    if (e case ReduxException(:final exitCode?)) {
      return exitCode;
    }

    if (e case UsageException() || ArgumentError()) {
      logger
        ..err(exception.toString())
        ..err('Rerun with --help for usage information.');
      return 64; // Exit code 64 indicates a usage error.
    }

    rethrow;
  }
}
