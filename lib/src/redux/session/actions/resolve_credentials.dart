import '../../actions/action.dart';

final class ResolveCredentialsAction extends AppAction {
  @override
  AppState reduce() {
    final host = logger
        .prompt(
          'Enter PocketBase host URL:',
          defaultValue: 'http://localhost:8090',
        )
        .trim();

    final usernameOrEmail = logger
        .prompt('Enter superuser username/email:', defaultValue: 'admin')
        .trim();

    final password = logger.prompt(
      'Enter superuser password:',
      hidden: true,
      defaultValue: 'password',
    );

    return state.copyWith.session(
      host: host,
      usernameOrEmail: usernameOrEmail,
      password: password,
    );
  }
}
