import 'dart:collection';

import 'package:mason_logger/mason_logger.dart';

import '../../extensions/string_style.dart';
import '../../redux/observers.dart';
import '../../redux/store.dart';
import 'app_state.dart';

class ReduxActionLogger extends ActionObserver<AppState> {
  ReduxActionLogger({required Logger logger}) : _logger = logger;

  final Logger _logger;

  final _stopwatches = HashMap<ReduxAction, Stopwatch>();

  @override
  void observe(
    ReduxAction<AppState> action,
    int dispatchCount, {
    bool ini = false,
  }) {
    final actionName = 'Action ${action.runtimeTypeString().bold.yellow}';
    final dispatchCountStr = dispatchCount.toString().bold.lightMagenta;
    final iniStr = (ini ? 'S' : 'E');
    final message = '$actionName D: $dispatchCountStr - $iniStr';
    
    if (ini) {
      assert(
        !_stopwatches.containsKey(action),
        'Stopwatch already exists for $actionName',
      );

      _stopwatches[action] = Stopwatch()..start();

      _logger.detail(message);
    } else {
      assert(
        _stopwatches.containsKey(action),
        'Stopwatch does not exist for $actionName',
      );

      final watch = _stopwatches.remove(action)!..stop();
      final elapsedStr = watch.toElapsedString();

      _logger.detail('$message ($elapsedStr)');
    }
  }
}

extension StopWatchExtension on Stopwatch {
  String toElapsedString() {
    final inMicroseconds = elapsedMicroseconds;
    final inMilliseconds = elapsedMilliseconds;
    final inSeconds = inMilliseconds ~/ 1000;

    if (inMicroseconds < 1000) {
      return '$inMicroseconds μs'.dim;
    } else if (inMilliseconds < 1000) {
      return '$inMilliseconds ms';
    } else if (inSeconds < 5) {
      return '${(inMilliseconds / 1000).toStringAsFixed(2)} s'.yellow;
    } else {
      final minutes = inSeconds ~/ 60;
      final seconds = inSeconds % 60;
      return '${minutes}m ${seconds}s'.red.bold;
    }
  }
}
