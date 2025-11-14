import 'package:mason_logger/mason_logger.dart';

import '../../redux/store.dart';
import 'app_state.dart';
import 'observers.dart';

final class Context {
  Context({required this.logger});

  final Logger logger;

  Store<AppState>? _store;

  Store<AppState> get store {
    _store ??= Store<AppState>(
      initialState: AppState.initial(),
      syncStream: true,
      actionObservers: [
        ReduxActionLogger(logger: logger),
      ],
    );

    return _store!;
  }
}
