import '../../../redux/store.dart';
import '../app_state.dart';

export '../app_state.dart';

abstract class AppAction extends ReduxAction<AppState> {
  Selectors get select => Selectors(state);
  
}
