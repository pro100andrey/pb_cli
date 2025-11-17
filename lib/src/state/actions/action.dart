import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../redux/store.dart';
import '../app_state.dart';
import '../selectors.dart';

export '../app_state.dart';

abstract class AppAction extends ReduxAction<AppState> {
  Selectors get select => Selectors(state);

  Logger get logger => store.prop();

  PocketBase get pb => store.prop();
}
