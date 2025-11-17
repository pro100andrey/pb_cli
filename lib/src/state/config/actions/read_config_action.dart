import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import '../../services/config_service.dart';

final class ReadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(ConfigService.fileName);
    final result = ConfigService().read(inputFile: file);

    final (
      :managedCollections,
      :credentialsSource,
    ) = result;

    logger.sectionTable(
      level: .verbose,
      title: 'Configuration:',
      items: {
        'Managed Collections': managedCollections.isNotEmpty
            ? managedCollections.join(', ')
            : '<none>',
        'Credentials Source': credentialsSource.key,
      },
    );

    return state.copyWith.config(
      managedCollections: result.managedCollections,
      credentialsSource: result.credentialsSource,
    );
  }
}
