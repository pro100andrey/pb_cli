import 'dart:async';

import '../../../extensions/logger.dart';
import '../../common/app_action.dart';
import '../../types/session_token.dart';

final class LogInAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    if (select.hasToken && select.isTokenValid) {
      pb.authStore.save(select.token!, null);
      logger.detail('Using existing authentication token.');

      return null;
    }

    await pb.health.check();

    final progress = logger.progress(
      'Logging in user ${select.usernameOrEmail}',
    );

    final result = await pb
        .collection('_superusers')
        .authWithPassword(select.usernameOrEmail!, select.password!);

    progress.complete('Logged in successfully.');

    logger.sectionMapped(
      level: .verbose,
      title: 'Session',
      items: {'Record id': result.record.id, 'Token': result.token},
    );

    return state.copyWith.session(token: SessionToken(result.token));
  }
}
