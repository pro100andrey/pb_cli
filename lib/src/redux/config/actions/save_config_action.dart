import '../../common/app_action.dart';
import '../../config/config_state.dart';
import '../../types/config.dart';
import '../config_persistence.dart';

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
      ConfigKey.managedCollections: select.managedCollections.unlockView,
      ConfigKey.credentialsSource: select.credentialsSource.key,
    });

    final file = select.configFilePath;

    writeConfig(data: data, file: file);

    logger.detail(
      'Wrote config file to: ${file.canonicalized}',
    );

    return state.copyWith.config(data: data);
  }
}
