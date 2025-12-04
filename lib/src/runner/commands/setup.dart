import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/actions/store_pocket_base_action.dart';
import '../../redux/app_state.dart';
import '../../redux/config/actions/load_config_action.dart';
import '../../redux/config/actions/save_config_action.dart';
import '../../redux/env/actions/load_env_action.dart';
import '../../redux/env/actions/save_env_action.dart';
import '../../redux/schema/actions/fetch_schema_action.dart';
import '../../redux/schema/actions/select_managed_collections_action.dart';
import '../../redux/session/actions/log_in_action.dart';
import '../../redux/session/actions/resolve_credentials.dart';
import '../../redux/session/actions/select_credentials_source_action.dart';
import '../../redux/work_dir/actions/resolve_work_dir_action.dart';
import '../../utils/strings.dart';
import 'base_command.dart';

class SetupCommand extends BaseCommand {
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
    final dirArg = argResults![S.dirOptionName];

    dispatchSync(ResolveWorkDirAction(path: dirArg, withUserPrompt: true));
    dispatchSync(LoadConfigAction());
    dispatchSync(LoadEnvAction());
    dispatchSync(ResolveCredentialsAction());

    dispatchSync(StorePocketBaseAction());

    await dispatchAndWait(LogInAction());
    await dispatchAndWait(FetchSchemaAction());

    dispatchSync(SelectManagedCollectionsAction());
    dispatchSync(SelectCredentialsSourceAction());
    dispatchSync(SaveConfigAction());
    dispatchSync(SaveEnvAction());

    return ExitCode.success.code;
  }
}
