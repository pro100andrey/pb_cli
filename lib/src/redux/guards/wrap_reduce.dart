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

    _applyWorkDirGuard(preSel, curSel);

    return newState;
  }

  /// Guard for work directory changes.
  /// Throws [PathNotFoundException] or [PathIsNotADirectoryException]
  /// if the new work directory is invalid.
  void _applyWorkDirGuard(Selectors preSel, Selectors curSel) {
    // If the current state allows creating the work directory,
    // no need to validate its existence.
    if (curSel.shouldCreateWorkDir) {
      return;
    }

    final oldWorkDir = preSel.workDirPath;
    final newWorkDir = curSel.workDirPath;

    if (oldWorkDir == null && newWorkDir != null) {
      if (newWorkDir case DirectoryPath(notFound: true)) {
        throw PathNotFoundException(newWorkDir.canonicalized);
      }

      if (newWorkDir case DirectoryPath(isDirectory: false)) {
        throw PathIsNotADirectoryException(newWorkDir.canonicalized);
      }
    }
  }
}
