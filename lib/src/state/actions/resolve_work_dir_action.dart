import '../../extensions/logger.dart';
import '../../extensions/string_style.dart';
import '../../utils/path.dart';
import '../../utils/validation.dart';
import 'action.dart';

final class ResolveWorkDirAction extends AppAction {
  ResolveWorkDirAction({required this.path});

  final String path;

  @override
  AppState reduce() {
    final workDir = DirectoryPath(path);

    final failure = workDir.validateIsDirectory();
    if (failure != null) {
      logger.err(failure.message);
      throw Exception(failure.message);
    }

    logger.sectionMapped(
      level: .verbose,
      title: 'Working directory:',
      items: {
        'Provided': path.lightYellow,
        'Canonicalized': workDir.canonicalized.lightYellow,
      },
    );

    return state.copyWith(workDir: workDir);
  }
}
