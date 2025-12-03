import 'dart:async';

import '../../../extensions/logger.dart';
import '../../action.dart';
import 'populate_session_from_env_action.dart';

final class LogInAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    dispatchSync(PopulateSessionFromEnvAction());

    if (select.tokenIsPresent && select.tokenIsValid) {
      pb.authStore.save(select.token!, null);
      logger.detail('Using existing authentication token.');

      return null;
    }

    final result = await pb
        .collection('_superusers')
        .authWithPassword(select.usernameOrEmail!, select.password!);

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
