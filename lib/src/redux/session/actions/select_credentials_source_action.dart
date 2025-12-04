import '../../common/app_action.dart';
import '../../models/enums/credentials_source.dart';

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

    return state.copyWith();
  }
}
