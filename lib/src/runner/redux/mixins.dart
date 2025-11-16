import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/store.dart';
import 'app_state.dart';
import 'context.dart';

mixin WithRedux on Command {
  /// The application context.
  Context get context;

  /// The logger.
  Logger get logger => context.logger;

  /// The Redux store.
  Store<AppState> get store => context.store;

  /// The current application state.
  AppState get state => store.state;

  /// Dispatch an action and wait for its completion.
  DispatchAndWait<AppState> get dispatchAndWait => store.dispatchAndWait;

  /// Dispatch an action synchronously.
  DispatchSync<AppState> get dispatchSync => store.dispatchSync;

  /// Selectors for accessing state properties.
  Selectors get select => Selectors(state);
}
