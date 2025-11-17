import 'dart:async';

import 'package:pocketbase/pocketbase.dart';

import '../../../extensions/logger.dart';
import '../../../redux/user_exception.dart';
import '../../actions/action.dart';
import '../../env/actions/write_env_action.dart';
import '../session_state.dart';

final class LogInAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    if (select.hasToken && select.tokenIsValid) {
      pb.authStore.save(select.token!, null);
      logger.detail('Using existing authentication token.');

      return null;
    }

    final userSession = select.session as SessionUser;

    final result = await pb
        .collection('_superusers')
        .authWithPassword(userSession.usernameOrEmail, userSession.password);

    dispatchSync(WriteEnvAction(token: pb.authStore.token));

    logger.sectionMapped(
      level: .verbose,
      title: 'Session',
      items: {
        'Record id': result.record.id,
        'Token': result.token,
      },
    );

    return null;
  }

  @override
  Object? wrapError(Object error, StackTrace stackTrace) {
    if (error case ClientException()) {
      return UserException(error.toString(), reason: 'Failed to log in.');
    }

    return super.wrapError(error, stackTrace);
  }
}
