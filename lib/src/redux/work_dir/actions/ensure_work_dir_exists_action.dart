import '../../common/app_action.dart';

final class EnsureWorkDirExistsAction extends AppAction {
  @override
  AppState? reduce() {
    final workDirPath = select.workDirPath!;
    if (workDirPath.notFound) {
      workDirPath.create(recursive: true);
      logger.info('Created working directory at ${workDirPath.path}');

      final workDir = select.resolvedWorkDir.copyWith(
        path: workDirPath.sync,
      );

      return state.copyWith(workDir: workDir);
    }

    logger.detail(
      'Working directory already exists at ${workDirPath.path}, '
      'no action taken.',
    );

    return null;
  }
}
