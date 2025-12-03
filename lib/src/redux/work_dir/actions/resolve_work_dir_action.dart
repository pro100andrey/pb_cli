import '../../../extensions/logger.dart';
import '../../../utils/path.dart';
import '../../action.dart';

/// Action to resolve and validate the working directory path.
///
/// Throws an exception if the provided path is not a valid directory.
final class ResolveWorkDirAction extends AppAction {
  ResolveWorkDirAction({required this.path, this.withUserPrompt = false});

  /// The path to resolve as the working directory.
  final String path;
  final bool withUserPrompt;

  @override
  AppState reduce() {
    final workDirPath = DirectoryPath(path);

    if (workDirPath.notFound && withUserPrompt) {
      logger.info(
        'The provided directory does not exist: ${workDirPath.canonicalized}',
      );
      final _ = logger.chooseAny<String>(
        'Please choose an option to proceed:',
        choices: ['Create new directory', 'Use different path'],
        defaultValues: ['Use different path'],
      );
    }

    logger.sectionMapped(
      level: .verbose,
      title: 'Working directory:',
      items: {
        'Provided': path,
        'Canonicalized': workDirPath.canonicalized,
        'Exists': workDirPath.notFound ? 'No' : 'Yes',
      },
    );

    return state.copyWith.workDir(path: workDirPath);
  }
}
