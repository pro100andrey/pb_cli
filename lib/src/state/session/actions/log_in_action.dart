import 'dart:async';

import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import 'populate_session_from_env_action.dart';

final class LogInAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    dispatchSync(PopulateSessionFromEnvAction());

    if (select.hasToken && select.tokenIsValid) {
      pb.authStore.save(select.token!, null);
      logger.detail('Using existing authentication token.');

      return null;
    }

    final session = select.session;

    final result = await pb
        .collection('_superusers')
        .authWithPassword(session.usernameOrEmail!, session.password!);

    // dispatchSync(WriteEnvAction(token: pb.authStore.token));

    logger.sectionMapped(
      level: .verbose,
      title: 'Session',
      items: {
        'Record id': result.record.id,
        'Token': result.token,
      },
    );

    return state.copyWith.session(token: result.token);
  }
}
