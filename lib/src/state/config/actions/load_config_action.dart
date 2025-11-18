import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import '../../services/config_service.dart';

final class LoadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDir.joinFile(ConfigService.fileName);
    final result = ConfigService().read(inputFile: file);

    final (
      :managedCollections,
      :credentialsSource,
    ) = result;

    logger.sectionMapped(
      level: .verbose,
      title: 'Configuration:',
      items: {
        'Managed Collections':
            managedCollections == null || managedCollections.isEmpty
            ? '<none>'
            : managedCollections.join(', '),
        'Credentials Source': credentialsSource == null
            ? '<not set>'
            : credentialsSource.key,
      },
    );

    return state.copyWith.config(
      managedCollections: result.managedCollections,
      credentialsSource: result.credentialsSource,
    );
  }
}
