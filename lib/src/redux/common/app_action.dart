import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../failure/failure.dart';
import '../app_state.dart';
import 'selectors.dart';

export '../app_state.dart';

/// Base action class for all Redux actions in the application.
///
/// Provides:
/// - [select]: Convenient access to state via [Selectors]
/// - [logger]: Mason logger for console output
/// - [pb]: PocketBase client instance
/// - Error wrapping for PocketBase [ClientException]s
///
/// All actions should extend this class and implement [reduce()].
abstract class AppAction extends ReduxAction<AppState> {
  /// Provides convenient read-only access to state properties.
  Selectors get select => Selectors(state);

  /// Mason logger for console output with progress indicators and styling.
  Logger get logger => store.prop();

  /// PocketBase client instance for API calls.
  PocketBase get pb => store.prop();

  /// Wraps PocketBase client exceptions into [ReduxException]s.
  ///
  /// Converts [ClientException]s from PocketBase SDK into proper
  /// [ReduxException]s with appropriate error messages and exit codes.
  @override
  Object? wrapError(Object error, StackTrace stackTrace) {
    if (error case ClientException()) {
      return ReduxException(
        message: error.response['message'],
        reason: error.url.toString(),
        code: error.statusCode,
        exitCode: Failure.exSoftware,
      );
    }

    return super.wrapError(error, stackTrace);
  }
}
