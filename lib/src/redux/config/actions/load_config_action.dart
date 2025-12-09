import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../config/config_state.dart';
import '../../types/config.dart';
import '../config_persistence.dart';

/// Loads configuration from config.json file into [ConfigState].
///
/// Reads the config.json file from the working directory and stores the
/// configuration data in the state. If the file doesn't exist, stores
/// an empty [ConfigData].
final class LoadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.configFilePath;
    final data = readConfig(file: file);

    logger.sectionMapped(
      level: .verbose,
      title: 'Configuration:',
      items: {
        'Managed Collections': data.managedCollections.isEmpty
            ? '<none>'
            : data.managedCollections.join(', '),
        'Credentials Source': data.credentialsSource.key,
      },
    );

    return state.copyWith.config(data: data);
  }
}
