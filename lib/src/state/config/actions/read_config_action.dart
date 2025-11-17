import '../../actions/action.dart';
import '../../services/config_service.dart';

final class ReadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(ConfigService.fileName);
    final result = ConfigService().read(inputFile: file);

    logger.detail(
      'Loaded config file from: ${file.canonicalized} '
      'hasData=${result != null}',
    );

    return state.copyWith.config(
      managedCollections: result?.managedCollections,
      credentialsSource: result?.credentialsSource,
    );
  }
}
