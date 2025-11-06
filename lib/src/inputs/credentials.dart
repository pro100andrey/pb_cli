import 'package:mason_logger/mason_logger.dart';

/// Abstract interface for credential input
abstract interface class CredentialsInput {
  String promptHost({String? defaultValue});
  String promptUsername({String? defaultValue});
  String promptPassword({String? defaultValue, bool hidden = true});
}

/// Console-based credential input implementation
final class ConsoleCredentialsInput implements CredentialsInput {
  ConsoleCredentialsInput(this._logger);

  final Logger _logger;

  @override
  String promptHost({String? defaultValue}) => _logger
      .prompt(
        'Enter PocketBase host URL:',
        defaultValue: defaultValue ?? 'http://localhost:8090',
      )
      .trim();

  @override
  String promptUsername({String? defaultValue}) => _logger
      .prompt(
        'Enter superuser username/email:',
        defaultValue: defaultValue,
      )
      .trim();

  @override
  String promptPassword({String? defaultValue, bool hidden = true}) =>
      _logger.prompt(
        'Enter superuser password:',
        hidden: hidden,
        defaultValue: defaultValue,
      );
}
