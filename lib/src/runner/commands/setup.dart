import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../failure/common.dart';
import '../../models/credentials_source.dart';
import '../../models/result.dart';
import '../../repositories/config.dart';
import '../../repositories/env.dart';
import '../../utils/path.dart';
import '../../utils/strings.dart';
import '../../utils/validation.dart';
import '../redux/actions/load_config_action.dart';
import '../redux/actions/load_env_action.dart';
import '../redux/actions/resolve_data_dir_action.dart';
import '../redux/context.dart';
import '../redux/mixins.dart';
import 'context.dart';

class SetupCommand extends Command with WithRedux {
  SetupCommand({required this.context}) {
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
  final Context context;

  final _envRepository = EnvRepository();
  final _configRepository = ConfigRepository();

  @override
  Future<int> run() async {

    final dirArg = argResults![S.dirOptionName];
    dispatchSync(ResolveDataDirAction(dir: dirArg));
    dispatchSync(LoadEnvAction());
    dispatchSync(LoadConfigAction());

    final dir = DirectoryPath(argResults![S.dirOptionName]);

    // Validate directory path
    if (dir.validateIsDirectory() case final failure?) {
      logger.err(failure.message);
      return failure.exitCode;
    }

    logger.info(S.setupDirectoryStart(dir.path));

    final ctxResult = await resolveCommandContext(dir: dir, logger: logger);
    if (ctxResult case Result(:final error?)) {
      return error.exitCode;
    }

    final (:inputs, :pbClient, :credentials) = ctxResult.value;

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
    final config = _configRepository.read(dataDir: dir);
    final dotenv = _envRepository.read(dataDir: dir);

    final managedCollections = setupInput.chooseCollections(
      choices: collectionsNames,
      defaultValues: config.managedCollections,
    );

    if (managedCollections.isEmpty) {
      logger.warn(S.noCollectionsSelected);
    }

    final source = CredentialsSource.fromTitle(
      setupInput.chooseCredentialsSource(
        choices: CredentialsSource.titles,
        defaultValue: config.credentialsSource.title,
      ),
    );

    final sourceChanged = source != config.credentialsSource;
    final managedCollectionsChanged = managedCollections
        .toSet()
        .difference(config.managedCollections.toSet())
        .isNotEmpty;

    if (!sourceChanged && !managedCollectionsChanged) {
      logger.info(S.setupAlreadyUpToDate);
      return ExitCode.success.code;
    }

    if (dir.notFound) {
      dir.create();
      logger.info(S.directoryCreated(dir.path));
    }

    switch (source) {
      case CredentialsSource.dotenv:
        final updatedDotenv = dotenv.copyWith(
          pbHost: credentials.host,
          pbUsername: credentials.usernameOrEmail,
          pbPassword: credentials.password,
          pbToken: pbClient.instance.authStore.token,
        );

        _envRepository.write(dotenv: updatedDotenv, dataDir: dir);
        logger.info(S.envFileUpdated);

      case _:
        logger.info(S.interactiveCredentialsSelected);
    }

    final updatedConfig = config.copyWith(
      managedCollections: managedCollections,
      credentialsSource: source,
    );

    _configRepository.write(config: updatedConfig, dataDir: dir);

    logger
      ..success(S.setupCompleted)
      ..info(S.setupNextSteps);

    return ExitCode.success.code;
  }
}
