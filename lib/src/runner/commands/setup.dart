import 'package:args/command_runner.dart';
import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/app_state.dart';
import '../../redux/config/config.dart';
import '../../redux/env/env.dart';
import '../../redux/schema/schema.dart';
import '../../redux/session/session.dart';
import '../../redux/work_dir/work_dir.dart';
import '../../utils/strings.dart';
import 'base_command.dart';

/// Command to set up the PocketBase CLI environment.
////
/// This command guides the user through the initial setup process,
/// including:
/// - Resolving the working directory
/// - Loading existing configuration and environment files
/// - Populating session credentials from environment variables
/// - Prompting the user for any missing credentials
/// - Validating credentials and establishing a connection to PocketBase
/// - Fetching the database schema
/// - Allowing the user to select managed collections and credential sources
/// - Saving the final configuration and environment settings
/// This command is typically run once during initial setup
/// or whenever the user wants to reconfigure their
/// PocketBase CLI environment.
class SetupCommand extends Command with WithStore {
  SetupCommand({required this.store}) {
    argParser.addOption(
      S.dirOptionName,
      abbr: S.dirOptionAbbr,
      help: S.dirOptionHelp,
      mandatory: true,
    );
  }

  @override
  final name = S.setupCommand;

  @override
  final description = S.setupDescription;

  @override
  final Store<AppState> store;

  @override
  Future<int> run() async {
    logger.info('Starting setup command...');

    // 1. Resolve working directory
    dispatchSync(ResolveWorkDirAction(path: argResults![S.dirOptionName]));

    // 2. Load existing config and env files
    dispatchSync(LoadConfigAction());
    dispatchSync(LoadEnvAction());

    // 3. Populate session from env (use existing values if available)
    dispatchSync(PopulateSessionFromEnvAction());

    // 4. Resolve missing credentials from user (only if needed)
    dispatchSync(ResolveCredentialsAction());
    dispatchSync(ValidateCredentialsAction());

    // 5. Setup PocketBase connection
    await dispatchAndWait(SetupPocketBaseConnectionAction());
    // 6. Authenticate
    await dispatchAndWait(LogInAction());

    // 7. Fetch schema and select collections/credentials source
    await dispatchAndWait(FetchSchemaAction());
    dispatchSync(SelectManagedCollectionsAction());
    dispatchSync(SelectCredentialsSourceAction());

    // 8. Persist configuration
    dispatchSync(EnsureWorkDirExistsAction());
    dispatchSync(SaveConfigAction());
    dispatchSync(SaveEnvAction());

    logger.success('Setup completed successfully.');

    return ExitCode.success.code;
  }
}
