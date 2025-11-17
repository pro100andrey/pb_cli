import 'package:mason_logger/mason_logger.dart';

import 'action.dart';

final class StoreLoggerAction extends AppAction {
  StoreLoggerAction({required this.logger});

  @override
  final Logger logger;

  @override
  AppState? reduce() {
    store.setProp(logger);
    logger.detail('Logger instance stored.');

    return null;
  }
}
