import 'dart:collection';

import 'package:mason_logger/mason_logger.dart';
import 'package:stack_trace/stack_trace.dart';

import '../extensions/string_style.dart';
import '../redux/observers.dart';
import '../redux/store.dart';
import '../redux/user_exception.dart';
import 'app_state.dart';

class AppActionLogger extends ActionObserver<AppState> {
  AppActionLogger({required Logger logger}) : _logger = logger;

  final Logger _logger;

  final _stopwatches = HashMap<ReduxAction, Stopwatch>();

  @override
  void observe(
    ReduxAction<AppState> action,
    int dispatchCount, {
    bool ini = false,
  }) {
    final type = action.runtimeTypeString();
    final an = action.status.isCompletedFailed ? type.red.bold : type;
    final dc = dispatchCount.toString();
    final st = action.isSync ? '∥'.gray : '∥'.lightMagenta;

    final i = ini ? '→'.gray : '←'.lightGreen;

    if (ini) {
      assert(
        !_stopwatches.containsKey(action),
        'Stopwatch already exists for $an',
      );

      _stopwatches[action] = Stopwatch()..start();
      _logger.detail('$i $an $st D:$dc');
    } else {
      assert(
        _stopwatches.containsKey(action),
        'Stopwatch does not exist for $an',
      );

      final watch = _stopwatches.remove(action)!..stop();
      final e = watch.toElapsedString();
      _logger.detail('$i $an $st D:$dc $e');
    }
  }
}

extension StopWatchExtension on Stopwatch {
  String toElapsedString() {
    final inMicroseconds = elapsedMicroseconds;
    final inMilliseconds = elapsedMilliseconds;
    final inSeconds = inMilliseconds ~/ 1000;

    if (inMicroseconds < 1000) {
      // ignore: unnecessary_brace_in_string_interps
      return '${inMicroseconds}μs'.dim;
    } else if (inMilliseconds < 1000) {
      return '${inMilliseconds}ms';
    } else if (inSeconds < 60) {
      return '${(inMilliseconds / 1000).toStringAsFixed(2)}s'.yellow;
    } else {
      final minutes = inSeconds ~/ 60;
      final seconds = inSeconds % 60;
      return '${minutes}m ${seconds}s'.red.bold;
    }
  }
}

class AppErrorObserver implements ErrorObserver<AppState> {
  AppErrorObserver({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  bool observe(
    Object error,
    StackTrace stackTrace,
    ReduxAction<AppState> action,
    Store store,
  ) {
    final trace = Trace.from(stackTrace);

    _logger
      ..err('Error during ${action.runtimeTypeString()}')
      ..detail(error.toString().box())
      ..detail(trace.toString());

    return true;
  }
}

class AppGlobalWrapError extends GlobalWrapError<AppState> {
  @override
  Object? wrap(Object error, StackTrace stackTrace, ReduxAction action) {
    if (error is UserException) {
      return error;
    }

    return UserException(null, reason: error.toString());
  }
}
