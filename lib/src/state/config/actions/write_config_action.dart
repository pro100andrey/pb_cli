import '../../../models/credentials_source.dart';
import '../../actions/action.dart';
import '../../services/config_service.dart';

final class WriteConfigAction extends AppAction {
  WriteConfigAction({
    required this.managedCollections,
    required this.credentialsSource,
  });

  final List<String> managedCollections;
  final CredentialsSource credentialsSource;

  @override
  AppState reduce() {
    final file = select.workDir.joinFile(ConfigService.fileName);

    ConfigService().write(
      outputFile: file,
      managedCollections: managedCollections,
      credentialsSource: credentialsSource,
    );

    logger.detail('Wrote config file to: ${file.canonicalized}');

    return state.copyWith.config(
      managedCollections: managedCollections,
      credentialsSource: credentialsSource,
    );
  }
}
