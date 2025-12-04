import '../../common.dart';

final class VerifyConnectionAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final health = await pb.health.check();
    if (health.code == 200) {
      logger.detail('PocketBase health check passed');
    }

    return null;
  }
}
