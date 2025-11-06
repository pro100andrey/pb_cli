import 'package:mason_logger/mason_logger.dart';

import 'credentials.dart';
import 'setup.dart';

final class InputsFactory {
  InputsFactory(this._logger);

  final Logger _logger;

  SetupInput createSetupInput() => ConsoleSetupInput(_logger);

  CredentialsInput createCredentialsInput() => ConsoleCredentialsInput(_logger);
}
