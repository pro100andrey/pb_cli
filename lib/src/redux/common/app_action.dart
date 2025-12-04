import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../failure/failure.dart';
import '../app_state.dart';
import 'selectors.dart';

export '../app_state.dart';

abstract class AppAction extends ReduxAction<AppState> {
  Selectors get select => Selectors(state);

  Logger get logger => store.prop();

  PocketBase get pb => store.prop();

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
