import 'package:cli_utils/cli_utils.dart';

import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../models/enums/command.dart';
import '../work_dir_state.dart';

/// Action to resolve and validate the working directory path.
///
/// Throws an exception if the provided path is not a valid directory.
final class ResolveWorkDirAction extends AppAction {
  ResolveWorkDirAction({required this.path, required this.context});

  /// The path to resolve as the working directory.
  final String path;

  /// The command context associated with the working directory.
  final CommandContext context;

  @override
  AppState reduce() {
    final workDirPath = DirectoryPath(path);

    logger.sectionMapped(
      level: .verbose,
      title: 'Resolved Working Directory:',
      items: {
        'Provided': path,
        'Canonicalized': workDirPath.canonicalized,
        'Exists': workDirPath.notFound ? 'No' : 'Yes',
      },
    );

    return state.copyWith(
      workDir: ResolvedWorkDir(path: workDirPath, context: context),
    );
  }
}
