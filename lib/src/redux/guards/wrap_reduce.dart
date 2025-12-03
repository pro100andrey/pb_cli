import 'package:cli_async_redux/cli_async_redux.dart';

import '../../utils/path.dart';
import '../app_state.dart';
import '../exeptions.dart';
import '../selectors.dart';

class GuardsWrapReduce extends WrapReduce<AppState> {
  @override
  AppState process({required AppState oldState, required AppState newState}) =>
      _applyGuards(oldState, newState);

  AppState _applyGuards(AppState oldState, AppState newState) {
    final preSel = Selectors(oldState);
    final curSel = Selectors(newState);

    _applyWorkDirGuard(preSel, curSel);

    return newState;
  }

  /// Guard for work directory changes.
  /// Throws [PathNotFoundException] or [PathIsNotADirectoryException]
  /// if the new work directory is invalid.
  void _applyWorkDirGuard(Selectors preSel, Selectors curSel) {
    final oldWorkDir = preSel.workDirPath;
    final newWorkDir = curSel.workDirPath;

    if (oldWorkDir == null &&
        newWorkDir != null &&
        !curSel.shouldCreateWorkDir) {
      if (newWorkDir case DirectoryPath(notFound: true)) {
        throw PathNotFoundException(newWorkDir.canonicalized);
      }

      if (newWorkDir case DirectoryPath(isDirectory: false)) {
        throw PathIsNotADirectoryException(newWorkDir.canonicalized);
      }
    }
  }
}
