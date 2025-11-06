import 'package:mason_logger/mason_logger.dart';

import '../../client/pb_client.dart';
import '../../extensions/string_style.dart';
import '../../failure/failure.dart';
import '../../inputs/factory.dart';
import '../../models/credentials.dart';
import '../../models/result.dart';
import '../../repositories/factory.dart';
import '../../utils/path.dart';

typedef CommandContext = ({
  RepositoryFactory repositories,
  InputsFactory inputs,
  PbClient pbClient,
  Credentials credentials,
});

Future<Result<CommandContext, Failure>> resolveCommandContext({
  required DirectoryPath dir,
  required Logger logger,
}) async {
  final repositories = RepositoryFactory(dir);
  final configRepository = repositories.createConfigRepository();
  final envRepository = repositories.createEnvRepository();

  final dotenv = envRepository.readEnv();
  final config = configRepository.readConfig();

  final inputs = InputsFactory(logger);

  if (!dotenv.isComplete) {
    logger.info(
      'Environment variables are incomplete. '
              'Falling back to command-line inputs.'
          .yellow,
    );
  }

  final credentialsResult = resolveCredentials(
    dotenv: dotenv,
    config: config,
    input: inputs.createCredentialsInput(),
  );

  if (credentialsResult case Result(:final error?)) {
    return Result.failure(error);
  }

  final credentials = credentialsResult.value;
  final pbResult = await resolvePbClient(
    host: credentials.host,
    usernameOrEmail: credentials.usernameOrEmail,
    password: credentials.password,
    token: credentials.token,
    logger: logger,
  );

  if (pbResult case Result(:final error?)) {
    return Result.failure(error);
  }

  return Result.success((
    repositories: repositories,
    inputs: inputs,
    pbClient: pbResult.value,
    credentials: credentials,
  ));
}
