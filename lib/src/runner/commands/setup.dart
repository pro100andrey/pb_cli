import 'package:mason_logger/mason_logger.dart';

import '../../failure/common.dart';
import '../../inputs/factory.dart';
import '../../models/credentials.dart';
import '../../models/credentials_source.dart';
import '../../models/result.dart';
import '../../redux/store.dart';
import '../../state/actions/action.dart';
import '../../state/actions/create_pb_connection.dart';
import '../../state/actions/resolve_data_dir_action.dart';
import '../../state/config/actions/read_config_action.dart';
import '../../state/config/actions/write_config_action.dart';
import '../../state/env/actions/read_env_action.dart';
import '../../state/env/actions/write_env_action.dart';
import '../../utils/path.dart';
import '../../utils/strings.dart';
import '../../utils/validation.dart';
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

    dispatchSync(ResolveDataDirAction(dir: dirArg), notify: false);
    dispatchSync(ReadEnvAction(), notify: false);
    dispatchSync(ReadConfigAction(), notify: false);

    await dispatchAndWait(CreatePBConnection(), notify: false);

    final inputs = InputsFactory(logger);
    final pbClient = await resolvePBConnection();

    final dir = DirectoryPath(argResults![S.dirOptionName]);

    // Validate directory path
    if (dir.validateIsDirectory() case final failure?) {
      logger.err(failure.message);
      return failure.exitCode;
    }

    logger.info(S.setupDirectoryStart(dir.path));

    // Fetch the current schema from the remote PocketBase instance
    final collectionsResult = await pbClient.getCollections();
    if (collectionsResult case Result(:final error?)) {
      logger.err(error.fetchCollectionsSchema);
      return error.exitCode;
    }

    final collections = collectionsResult.value;
    final userCollections = collections.where((e) => !e.system);
    final collectionsNames = userCollections.map((e) => e.name).toList();

    final setupInput = inputs.createSetupInput();

    final managedCollections = setupInput.chooseCollections(
      choices: collectionsNames,
      defaultValues: select.managedCollections,
    );

    if (managedCollections.isEmpty) {
      logger.warn(S.noCollectionsSelected);
    }

    final source = CredentialsSource.fromTitle(
      setupInput.chooseCredentialsSource(
        choices: CredentialsSource.titles,
        defaultValue: select.credentialsSource.title,
      ),
    );

    final sourceChanged = source != select.credentialsSource;
    final managedCollectionsChanged = managedCollections
        .toSet()
        .difference(select.managedCollections.toSet())
        .isNotEmpty;

    if (!sourceChanged && !managedCollectionsChanged) {
      logger.info(S.setupAlreadyUpToDate);
      return ExitCode.success.code;
    }

    if (dir.notFound) {
      dir.create();
      logger.info(S.directoryCreated(dir.path));
    }

    final credentials = store.prop<Credentials>();

    switch (source) {
      case CredentialsSource.dotenv:
        dispatchSync(
          WriteEnvAction(
            host: credentials.host,
            usernameOrEmail: credentials.usernameOrEmail,
            password: credentials.password,
            token: credentials.token,
          ),
        );
        logger.info(S.envFileUpdated);

      case _:
        logger.info(S.interactiveCredentialsSelected);
    }

    dispatchSync(
      WriteConfigAction(
        managedCollections: managedCollections,
        credentialsSource: source,
      ),
    );

    logger
      ..success(S.setupCompleted)
      ..info(S.setupNextSteps);

    return ExitCode.success.code;
  }
}
