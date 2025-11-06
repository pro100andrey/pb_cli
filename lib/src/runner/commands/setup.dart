import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../failure/common.dart';
import '../../models/credentials_source.dart';
import '../../models/result.dart';
import '../../utils/path.dart';
import '../../utils/strings.dart';
import '../../utils/validation.dart';
import 'context.dart';

class SetupCommand extends Command {
  SetupCommand({required Logger logger}) : _logger = logger {
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

  final Logger _logger;

  @override
  Future<int> run() async {
    final dirPath = argResults![S.dirOptionName] as String;
    final dir = DirectoryPath(dirPath);

    // Validate directory path
    if (dir.validateIsDirectory() case final failure?) {
      _logger.err(failure.message);
      return failure.exitCode;
    }

    _logger.info(S.setupDirectoryStart(dir.path));

    final ctxResult = await resolveCommandContext(dir: dir, logger: _logger);
    if (ctxResult case Result(:final error?)) {
      return error.exitCode;
    }

    final (
      :repositories,
      :inputs,
      :pbClient,
      :credentials,
    ) = ctxResult.value;

    final configRepository = repositories.createConfigRepository();
    final config = configRepository.readConfig();

    final envRepository = repositories.createEnvRepository();
    final dotenv = envRepository.readEnv();

    // Fetch the current schema from the remote PocketBase instance
    final collectionsResult = await pbClient.getCollections();
    if (collectionsResult case Result(:final error?)) {
      _logger.err(error.fetchCollectionsSchema);
      return error.exitCode;
    }

    final collections = collectionsResult.value;
    final userCollections = collections.where((e) => !e.system);
    final collectionsNames = userCollections.map((e) => e.name).toList();

    final setupInput = inputs.createSetupInput();

    final managedCollections = setupInput.chooseCollections(
      choices: collectionsNames,
      defaultValues: config.managedCollections,
    );

    if (managedCollections.isEmpty) {
      _logger.warn(S.noCollectionsSelected);
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
      _logger.info(S.setupAlreadyUpToDate);
      return ExitCode.success.code;
    }

    if (dir.notFound) {
      dir.create();
      _logger.info(S.directoryCreated(dir.path));
    }

    switch (source) {
      case CredentialsSource.dotenv:
        envRepository.writeEnv(
          dotenv.copyWith(
            pbHost: credentials.host,
            pbUsername: credentials.usernameOrEmail,
            pbPassword: credentials.password,
            pbToken: pbClient.instance.authStore.token,
          ),
        );

        _logger.info(S.envFileUpdated);

      case _:
        _logger.info(S.interactiveCredentialsSelected);
    }

    configRepository.writeConfig(
      config.copyWith(
        managedCollections: managedCollections,
        credentialsSource: source,
      ),
    );
    _logger
      ..success(S.setupCompleted)
      ..info(S.setupNextSteps);

    return ExitCode.success.code;
  }
}
