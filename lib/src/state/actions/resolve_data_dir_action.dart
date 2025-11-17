import '../../utils/path.dart';
import '../../utils/validation.dart';
import 'action.dart';

final class ResolveDataDirAction extends AppAction {
  ResolveDataDirAction({required this.dir});

  final String dir;

  @override
  AppState reduce() {
    final dirPath = DirectoryPath(dir);

    final failure = dirPath.validateIsDirectory();
    if (failure != null) {
      logger.err(failure.message);
      throw Exception(failure.message);
    }

    logger.detail('Work dir: ${dirPath.canonicalized}');

    return state.copyWith(workDir: dirPath);
  }
}
