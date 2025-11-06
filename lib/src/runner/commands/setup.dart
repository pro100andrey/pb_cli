import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../client/pb_client.dart';
import '../../extensions/string_style.dart';
import '../../inputs/factory.dart';
import '../../models/credentials.dart';
import '../../models/credentials_source.dart';
import '../../models/failure.dart';
import '../../models/result.dart';
import '../../repositories/factory.dart';
import '../../utils/path.dart';

class SetupCommand extends Command {
  SetupCommand({required Logger logger}) : _logger = logger {
    argParser.addOption(
      'dir',
      abbr: 'd',
      help:
          'The local working directory for storing the PocketBase schema, '
          'config, and seed data files.',
      mandatory: true,
    );
  }

  @override
  final name = 'setup';

  @override
  final description =
      'Setup the local environment for managing PocketBase schema and data.';

  final Logger _logger;

  @override
  Future<int> run() async {
    final dir = DirectoryPath(argResults!['dir']);
    if (dir.validate() case final Failure result) {
      return result.exitCode;
    }

    _logger.info('Configuring setup...');

    final repositories = RepositoryFactory(dir);
    final configRepository = repositories.createConfigRepository();
    final envRepository = repositories.createEnvRepository();

    final inputs = InputsFactory(_logger);

    final dotenv = envRepository.readEnv();
    final config = configRepository.readConfig();

    final credentialsResult = resolveCredentials(
      dotenv: dotenv,
      config: config,
      input: inputs.createCredentialsInput(),
    );

    if (credentialsResult case Result(:final error?)) {
      _logger.err(error.message);
      return error.exitCode;
    }

    final credentials = credentialsResult.value;
    final pbResult = await resolvePbClient(
      host: credentials.host,
      usernameOrEmail: credentials.usernameOrEmail,
      password: credentials.password,
      token: credentials.token,
    );

    if (pbResult case Result(:final error?)) {
      _logger.err('Failed to connect to PocketBase: ${error.message}');
      return error.exitCode;
    }

    final pb = pbResult.value;

    // Fetch the current schema from the remote PocketBase instance
    final collectionsResult = await pb.getCollections();
    if (collectionsResult case Result(:final error?)) {
      _logger.err('Failed to fetch collections: ${error.message}');
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
      _logger.warn('No collections selected for management');
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
      _logger.info('Setup is already up to date.'.green);
      return ExitCode.success.code;
    }

    if (dir.notFound) {
      dir.create();
      _logger.info('Created directory: ${dir.path}');
    }

    switch (source) {
      case CredentialsSource.dotenv:
        envRepository.writeEnv(
          dotenv.copyWith(
            pbHost: credentials.host,
            pbUsername: credentials.usernameOrEmail,
            pbPassword: credentials.password,
            pbToken: pb.instance.authStore.token,
          ),
        );

        _logger.info('.env file updated with provided credentials.');

      case _:
        _logger.info('Using interactive credentials; no .env update needed.');
    }

    configRepository.writeConfig(
      config.copyWith(
        managedCollections: managedCollections,
        credentialsSource: source,
      ),
    );
    _logger
      ..success('Setup completed successfully!')
      ..info(
        'You can now use other commands to manage your PocketBase data.',
      );

    return ExitCode.success.code;
  }
}
