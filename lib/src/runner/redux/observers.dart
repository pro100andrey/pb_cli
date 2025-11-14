import 'package:mason_logger/mason_logger.dart';

import '../../extensions/string_style.dart';
import '../../redux/observers.dart';
import '../../redux/store.dart';
import 'app_state.dart';

class ReduxActionLogger extends ActionObserver<AppState> {
  ReduxActionLogger({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void observe(
    ReduxAction<AppState> action,
    int dispatchCount, {
    bool ini = false,
  }) {
    if (ini) {
      final watch = Stopwatch()..start();
      
    }

    final actionName = action.toString();
    final dispatchCountStr = dispatchCount.toString().bold.cyan;

    _logger.detail(
      '$actionName '
      'D: $dispatchCountStr - ${ini ? 'start'.green : 'end'.green}',
    );
  }
}
