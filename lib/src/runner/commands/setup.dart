import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/actions/resolve_work_dir_action.dart';
import '../../redux/actions/store_pocket_base_action.dart';
import '../../redux/app_state.dart';
import '../../redux/config/actions/load_config_action.dart';
import '../../redux/env/actions/load_env_action.dart';
import '../../redux/schema/actions/fetch_schema_action.dart';
import '../../redux/schema/actions/select_managed_collections_action.dart';
import '../../redux/session/actions/log_in_action.dart';
import '../../redux/session/actions/resolve_credentials.dart';
import '../../redux/session/actions/select_credentials_source_action.dart';
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

    dispatchSync(ResolveWorkDirAction(path: dirArg));
    dispatchSync(LoadConfigAction());
    dispatchSync(LoadEnvAction());
    dispatchSync(ResolveCredentialsAction());
    dispatchSync(StorePocketBaseAction());

    await dispatchAndWait(LogInAction());
    await dispatchAndWait(FetchSchemaAction());

    dispatchSync(SelectManagedCollectionsAction());
    dispatchSync(SelectCredentialsSourceAction());

    // final inputs = InputsFactory(logger);
    // final pbClient = await resolvePBConnection();

    // final dir = DirectoryPath(argResults![S.dirOptionName]);

    // // Validate directory path
    // if (dir.validateIsDirectory() case final failure?) {
    //   logger.err(failure.message);
    //   return failure.exitCode;
    // }

    // logger.info(S.setupDirectoryStart(dir.path));

    // // Fetch the current schema from the remote PocketBase instance
    // final collectionsResult = await pbClient.getCollections();
    // if (collectionsResult case Result(:final error?)) {
    //   logger.err(error.fetchCollectionsSchema);
    //   return error.exitCode;
    // }

    // final collections = collectionsResult.value;
    // final userCollections = collections.where((e) => !e.system);
    // final collectionsNames = userCollections.map((e) => e.name).toList();

    // final setupInput = inputs.createSetupInput();

    // final managedCollections = setupInput.chooseCollections(
    //   choices: collectionsNames,
    //   defaultValues: select.managedCollections,
    // );

    // if (managedCollections.isEmpty) {
    //   logger.warn(S.noCollectionsSelected);
    // }

    // final source = CredentialsSource.fromTitle(
    //   setupInput.chooseCredentialsSource(
    //     choices: CredentialsSource.titles,
    //     defaultValue: select.credentialsSource.title,
    //   ),
    // );

    // final sourceChanged = source != select.credentialsSource;
    // final managedCollectionsChanged = managedCollections
    //     .toSet()
    //     .difference(select.managedCollections.toSet())
    //     .isNotEmpty;

    // if (!sourceChanged && !managedCollectionsChanged) {
    //   logger.info(S.setupAlreadyUpToDate);
    //   return ExitCode.success.code;
    // }

    // if (dir.notFound) {
    //   dir.create();
    //   logger.info(S.directoryCreated(dir.path));
    // }

    // final credentials = store.prop<Credentials>();

    // switch (source) {
    //   case CredentialsSource.dotenv:
    //     dispatchSync(
    //       WriteEnvAction(
    //         host: credentials.host,
    //         usernameOrEmail: credentials.usernameOrEmail,
    //         password: credentials.password,
    //         token: credentials.token,
    //       ),
    //     );
    //     logger.info(S.envFileUpdated);

    //   case _:
    //     logger.info(S.interactiveCredentialsSelected);
    // }

    // dispatchSync(
    //   WriteConfigAction(
    //     managedCollections: managedCollections,
    //     credentialsSource: source,
    //   ),
    // );

    // logger
    //   ..success(S.setupCompleted)
    //   ..info(S.setupNextSteps);

    return ExitCode.success.code;
  }
}
