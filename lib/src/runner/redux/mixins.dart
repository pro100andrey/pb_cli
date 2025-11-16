import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/store.dart';
import 'app_state.dart';

mixin WithStore on Command {
  Store<AppState> get store;

  /// The logger.
  Logger get logger => store.prop();

  /// The current application state.
  AppState get state => store.state;

  /// Dispatch an action and wait for its completion.
  DispatchAndWait<AppState> get dispatchAndWait => store.dispatchAndWait;

  /// Dispatch an action synchronously.
  DispatchSync<AppState> get dispatchSync => store.dispatchSync;

  /// Selectors for accessing state properties.
  Selectors get select => Selectors(state);
}
