import '../../common/app_action.dart';

final class EnsureWorkDirExistsAction extends AppAction {
  @override
  AppState? reduce() {
    if (!select.shouldCreateWorkDir) {
      return null;
    }

    final workDirPath = select.workDirPath!;
    if (workDirPath.notFound) {
      workDirPath.create(recursive: true);
      logger.info('Created working directory at ${workDirPath.path}');

      return state.copyWith.workDir(path: workDirPath.sync);
    }

    return null;
  }
}
