import '../../../extensions/logger.dart';
import '../../action.dart';
import '../../services/config_service.dart';

final class LoadConfigAction extends AppAction {
  @override
  AppState reduce() {
    final file = select.workDirPath!.joinFile(ConfigService.fileName);

    final (
      :managedCollections,
      :credentialsSource,
    ) = ConfigService.read(inputFile: file);

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
      managedCollections: managedCollections,
      credentialsSource: credentialsSource,
    );
  }
}
