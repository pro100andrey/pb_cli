import 'dart:async';

import 'package:pocketbase/pocketbase.dart';

import 'action.dart';

final class StorePocketBaseAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final host = select.pbHost!;
    final pocketBase = PocketBase(host);

    // Save PocketBase instance to the store
    store.setProp<PocketBase>(pocketBase);

    if (select.tokenIsValid) {
      pocketBase.authStore.save(select.pbToken!, null);
      logger.info('Using existing authentication token.');
    }

    return null;

    //   final dotenv = select.dotenv;
    //   final config = select.config;

    //   if (dotenv.isComplete && config.credentialsSource.isDotenv) {
    //     final credentials = Credentials(
    //       host: dotenv.pbHost!,
    //       usernameOrEmail: dotenv.pbUsername!,
    //       password: dotenv.pbPassword!,
    //       token: dotenv.pbToken,
    //     );
    //   }

    //   // Fall back to interactive prompting
    //   final hostResponse = input.promptHost(
    //     defaultValue: 'http://localhost:8090',
    //   );

    //   // Prompt for username/email
    //   final usernameResponse = input.promptUsername(defaultValue: 'admin');

    //   // Prompt for password (hidden input)
    //   final passwordResponse = input.promptPassword(defaultValue: 'password');

    //   final credentials = Credentials(
    //     host: hostResponse,
    //     usernameOrEmail: usernameResponse,
    //     password: passwordResponse,
    //     token: null,
    //   );
    //   return null;
  }
}
