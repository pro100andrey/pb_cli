import '../../common/app_action.dart';
import '../../models/enums/credentials_source.dart';
import '../../types/config.dart';

final class SelectCredentialsSourceAction extends AppAction {
  @override
  AppState? reduce() {
    final choice = logger.chooseOne(
      'Select authentication method:',
      choices: CredentialsSource.values,
      defaultValue: select.credentialsSource,
      display: (source) => source.title,
    );

    final sourceChanged = choice != select.credentialsSource;
    if (!sourceChanged) {
      logger.info('Credentials source is already up to date.');
      return null;
    }

    final newData = ConfigData.data({
      ConfigKey.managedCollections: select.managedCollections,
      ConfigKey.credentialsSource: choice.key,
    });

    return state.copyWith.config(data: newData);
  }
}
