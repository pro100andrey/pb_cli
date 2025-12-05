import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:cli_utils/cli_utils.dart';

import '../app_state.dart';
import '../common/exceptions.dart';
import '../common/selectors.dart';

class GuardsWrapReduce extends WrapReduce<AppState> {
  @override
  AppState process({required AppState oldState, required AppState newState}) =>
      _applyGuards(oldState, newState);

  AppState _applyGuards(AppState oldState, AppState newState) {
    final preSel = Selectors(oldState);
    final curSel = Selectors(newState);

    _workDirExistGuard(preSel, curSel);

    return newState;
  }

  void _workDirExistGuard(Selectors preSel, Selectors curSel) {
    final oldWorkDir = preSel.workDirPath;
    final newWorkDir = curSel.workDirPath;

    if (oldWorkDir == null && newWorkDir != null) {
      // If path exists but is not a directory (e.g., it's a file)
      if (newWorkDir case DirectoryPath(isDirectory: false, notFound: false)) {
        throw PathIsNotADirectoryException(newWorkDir.canonicalized);
      }

      // If path doesn't exist, check if it can be created
      if (newWorkDir case DirectoryPath(notFound: true)) {
        if (!newWorkDir.canBeCreated) {
          throw PathCannotBeCreatedException(newWorkDir.canonicalized);
        }
      }
    }
  }
}
