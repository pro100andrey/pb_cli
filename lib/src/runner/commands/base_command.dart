import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../client/pb_client.dart';
import '../../inputs/factory.dart';
import '../../models/credentials.dart';
import '../../redux/store.dart';
import '../../state/actions/action.dart';

mixin WithStore {
  Logger get logger => store.prop();

  PbClient get pbClient => store.prop();

  /// Selectors for accessing state properties.
  Selectors get select => Selectors(store.state);

  Store<AppState> get store;

  /// Dispatch an action and wait for its completion.
  DispatchAndWait<AppState> get dispatchAndWait => store.dispatchAndWait;

  /// Dispatch an action synchronously.
  DispatchSync<AppState> get dispatchSync => store.dispatchSync;

  List<ReduxAction<AppState>> Function(
    List<ReduxAction<AppState>> actions, {
    bool notify,
  })
  get dispatchAll => store.dispatchAll;
}

abstract class BaseCommand extends Command with WithStore {
  void resolveDataDir(String dir) {}

  Future<PbClient> resolvePBConnection() async {
    final inputs = InputsFactory(logger);

    final credentials = resolveCredentials(
      input: inputs.createCredentialsInput(),
    );

    final pbResult = await resolvePbClient(
      host: credentials.host,
      usernameOrEmail: credentials.usernameOrEmail,
      password: credentials.password,
      token: credentials.token,
      logger: logger,
    );

    store
      ..setProp(pbResult.value)
      ..setProp(credentials);

    final pbClient = pbResult.value;

    return pbClient;
  }
}
