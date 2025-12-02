import '../../extensions/logger.dart';
import '../../utils/path.dart';
import '../exeptions.dart';
import 'action.dart';

/// Action to resolve and validate the working directory path.
///
/// Throws an exception if the provided path is not a valid directory.
final class ResolveWorkDirAction extends AppAction {
  ResolveWorkDirAction({required this.path});

  /// The path to resolve as the working directory.
  final String path;

  @override
  AppState reduce() {
    final workDir = DirectoryPath(path);

    if (workDir case DirectoryPath(notFound: true)) {
      throw PathNotFoundException(path);
    }

    if (workDir case DirectoryPath(isDirectory: false)) {
      throw PathIsNotADirectoryException(path);
    }

    logger.sectionMapped(
      level: .verbose,
      title: 'Working directory:',
      items: {
        'Provided': path,
        'Canonicalized': workDir.canonicalized,
        'Exists': workDir.notFound ? 'No' : 'Yes',
      },
    );

    return state.copyWith(workDir: workDir);
  }
}
