import '../../actions/action.dart';
import '../../services/config_service.dart';

final class SaveConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(ConfigService.fileName);

    final managedCollections = select.managedCollections;
    final credentialsSource = select.credentialsSource;

    ConfigService().write(
      outputFile: file,
      managedCollections: managedCollections,
      credentialsSource: credentialsSource,
    );

    logger.detail('Wrote config file to: ${file.canonicalized}');

    return state.copyWith.config(
      managedCollections: managedCollections,
      credentialsSource: credentialsSource,
    );
  }
}
