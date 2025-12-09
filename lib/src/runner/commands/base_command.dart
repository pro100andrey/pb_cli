import 'package:cli_async_redux/cli_async_redux.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../redux/common.dart';

mixin WithStore {
  Logger get logger => store.prop();

  /// Selectors for accessing state properties.
  Selectors get select => Selectors(store.state);

  Store<AppState> get store;

  /// Dispatch an action and wait for its completion.
  DispatchAndWait<AppState> get dispatchAndWait => store.dispatchAndWait;

  /// Dispatch an action synchronously.
  DispatchSync<AppState> get dispatchSync => store.dispatchSync;

  List<ReduxAction<AppState>> Function(List<ReduxAction<AppState>> actions)
  get dispatchAll => store.dispatchAll;
}
