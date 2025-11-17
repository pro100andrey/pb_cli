import 'dart:async';

import '../../../extensions/logger.dart';
import '../../actions/action.dart';
import '../../env/actions/write_env_action.dart';

final class LogInAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    if (select.hasToken && select.tokenIsValid) {
      pb.authStore.save(select.token!, null);
      logger.detail('Using existing authentication token.');

      return null;
    }

    final usernameOrEmail = select.usernameOrEmail!;
    final password = select.password!;

    final result = await pb
        .collection('_superusers')
        .authWithPassword(usernameOrEmail, password);

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
}
