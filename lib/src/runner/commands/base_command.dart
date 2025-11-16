import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import '../../client/pb_client.dart';
import '../../inputs/factory.dart';
import '../../models/credentials.dart';
import '../../redux/store.dart';
import '../redux/actions/action.dart';
import '../redux/actions/config_actions.dart';
import '../redux/actions/env_actions.dart';
import '../redux/actions/resolve_data_dir_action.dart';

abstract class BaseCommand extends Command {
  Store<AppState> get store;

  /// The logger.
  Logger get logger => store.prop();

  /// Dispatch an action and wait for its completion.
  DispatchAndWait<AppState> get dispatchAndWait => store.dispatchAndWait;

  /// Dispatch an action synchronously.
  DispatchSync<AppState> get dispatchSync => store.dispatchSync;

  List<ReduxAction<AppState>> Function(
    List<ReduxAction<AppState>> actions, {
    bool notify,
  })
  get dispatchAll => store.dispatchAll;

  /// Selectors for accessing state properties.
  Selectors get select => Selectors(store.state);

  void resolveDataDir(String dir) {
    dispatchAll(
      [
        ResolveDataDirAction(dir: dir),
        LoadEnvAction(),
        LoadConfigAction(),
      ],
      notify: false,
    );
  }

  Future<PbClient> resolvePBConnection() async {
    final inputs = InputsFactory(logger);

    final credentials = resolveCredentials(
      dotenv: select.dotenv,
      config: select.config,
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
