import '../../common/app_action.dart';
import '../../config/config_state.dart';
import '../../services/config_service.dart';
import '../../types/config.dart';

/// Saves current configuration to config.json file.
///
/// Takes values from selectors (managedCollections, credentialsSource)
/// and writes them to the config.json file in the working directory.
///
/// This updates both the file on disk and the [ConfigState] to reflect
/// the saved values.
final class SaveConfigAction extends AppAction {
  @override
  AppState reduce() {
    final data = ConfigData.data({
      ConfigKey.managedCollections: select.managedCollections,
      ConfigKey.credentialsSource: select.credentialsSource.key,
    });

    final file = select.workDirPath!.joinFile(ConfigService.fileName);

    ConfigService.write(outputFile: file, data: data);

    logger.detail('Wrote config file to: ${file.canonicalized}');

    return state.copyWith.config(data: data);
  }
}
