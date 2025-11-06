import 'package:mason_logger/mason_logger.dart';

abstract interface class SetupInput {
  /// Prompts user to select multiple collections from available options
  List<String> chooseCollections({
    required List<String> choices,
    List<String>? defaultValues,
  });

  /// Prompts user to select a credentials source
  String chooseCredentialsSource({
    required List<String> choices,
    String? defaultValue,
  });
}

/// Console-based implementation for setup interactions
final class ConsoleSetupInput implements SetupInput {
  ConsoleSetupInput(this._logger);

  final Logger _logger;

  @override
  List<String> chooseCollections({
    required List<String> choices,

    List<String>? defaultValues,
  }) => _logger.chooseAny(
    'Select collections to synchronize:',
    choices: choices,
    defaultValues: defaultValues ?? [],
  );

  @override
  String chooseCredentialsSource({
    required List<String> choices,
    String? defaultValue,
  }) => _logger.chooseOne(
    'Select authentication method:',
    choices: choices,
    defaultValue: defaultValue,
  );
}
