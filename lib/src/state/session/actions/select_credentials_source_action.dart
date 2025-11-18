import '../../../models/credentials_source.dart';
import '../../actions/action.dart';

final class SelectCredentialsSourceAction extends AppAction {
  @override
  AppState? reduce() {
    final selected = logger.chooseOne(
      'Select authentication method:',
      choices: CredentialsSource.titles,
      defaultValue: select.credentialsSource.title,
    );

    final source = CredentialsSource.fromTitle(selected);

    final sourceChanged = source != select.credentialsSource;

    if (!sourceChanged) {
      logger.info('Credentials source is already up to date.');
      return null;
    }

    return state.copyWith();
  }
}
