import 'dart:async';

import 'package:pocketbase/pocketbase.dart';

import 'action.dart';

final class CreatePBConnection extends AppAction {
  @override
  Future<AppState?> reduce() async {

    final auth = AuthStore();

    final token = select.pbToken;

    if (token != null && token.isNotEmpty) {
      auth.save(token, null);
     
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
