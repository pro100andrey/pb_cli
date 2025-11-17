import 'package:mason_logger/mason_logger.dart';

import '../../client/pb_client.dart';
import '../../redux/store.dart';
import '../app_state.dart';

export '../app_state.dart';

abstract class AppAction extends ReduxAction<AppState> {
  Selectors get select => Selectors(state);

  Logger get logger => store.prop();

  PbClient get pbClient => store.prop();
}
