import 'package:args/command_runner.dart';
import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/actions/store_pocket_base_action.dart';
import '../../redux/app_state.dart';
import '../../redux/config/config.dart';
import '../../redux/env/env.dart';
import '../../redux/schema/schema.dart';
import '../../redux/session/session.dart';
import '../../redux/work_dir/work_dir.dart';
import '../../utils/strings.dart';
import 'base_command.dart';

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
    dispatchSync(
      ResolveWorkDirAction(
        path: argResults![S.dirOptionName],
        withUserPrompt: true,
      ),
    );

    // 2. Load existing config and env files
    dispatchSync(LoadConfigAction());
    dispatchSync(LoadEnvAction());

    // 3. Populate session from env (use existing values if available)
    dispatchSync(PopulateSessionFromEnvAction());

    // 4. Resolve missing credentials from user (only if needed)
    dispatchSync(ResolveCredentialsAction());
    dispatchSync(ValidateCredentialsAction());

    // 5. Store PocketBase instance info
    dispatchSync(StorePocketBaseAction());

    // 6. Authenticate and fetch schema
    await dispatchAndWait(VerifyConnectionAction());
    await dispatchAndWait(LogInAction());
    await dispatchAndWait(FetchSchemaAction());

    // 7. Configure managed collections and auth method
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
