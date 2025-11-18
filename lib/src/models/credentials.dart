import '../failure/failure.dart';
import '../inputs/credentials.dart';
import 'config.dart';
import 'dotenv.dart';

/// Model class to hold PocketBase admin credentials.
///
/// This class encapsulates all the necessary authentication information
/// required to connect to and authenticate with a PocketBase instance,
/// including host URL, user credentials, and optional authentication token.
final class Credentials {
  /// Creates a new Credentials instance.
  ///
  /// [host] The PocketBase instance URL (e.g., 'http://localhost:8090').
  /// [usernameOrEmail] The admin username or email address.
  /// [password] The admin password.
  /// [token] Optional authentication token for pre-authenticated sessions.
  const Credentials({
    required this.host,
    required this.usernameOrEmail,
    required this.password,
    required this.token,
  });

  /// The PocketBase instance URL.
  ///
  /// This should be a complete URL including protocol and port if necessary.
  /// Example: 'http://localhost:8090' or 'https://api.example.com'
  final String host;

  /// The admin username or email.
  ///
  /// This can be either a username or email address depending on how
  /// the PocketBase admin account was configured.
  final String usernameOrEmail;

  /// The admin password.
  ///
  /// The password associated with the admin account for authentication.
  final String password;

  /// The admin authentication token.
  ///
  /// Optional token that can be used for pre-authenticated sessions.
  /// When null, authentication will be performed using username/password.
  final String? token;
}

/// Resolves PocketBase admin credentials from available sources.
///
/// This function attempts to resolve credentials in the following order:
/// 1. From environment variables (dotenv) if configured and complete
/// 2. By prompting the user for input via the provided input interface
///
/// [input] The interface for gathering user input when needed.
///
/// Returns a [CliResult] containing either the resolved [Credentials] or
/// a [Failure] if the credentials could not be obtained.
Credentials resolveCredentials({
  // required Dotenv dotenv,
  // required Config config,
  required CredentialsInput input,
}) {
  const dotenv = Dotenv.empty();
  const config = Config.empty();
  // Try to use dotenv credentials if available and configured
  if (dotenv.hasData && config.credentialsSource.isDotenv) {
    final credentials = Credentials(
      host: dotenv.pbHost!,
      usernameOrEmail: dotenv.pbUsername!,
      password: dotenv.pbPassword!,
      token: dotenv.pbToken,
    );

    return credentials;
  }

  // Fall back to interactive prompting
  final hostResponse = input.promptHost(defaultValue: 'http://localhost:8090');

  // Prompt for username/email
  final usernameResponse = input.promptUsername(defaultValue: 'admin');

  // Prompt for password (hidden input)
  final passwordResponse = input.promptPassword(defaultValue: 'password');

  final credentials = Credentials(
    host: hostResponse,
    usernameOrEmail: usernameResponse,
    password: passwordResponse,
    token: null,
  );

  return credentials;
}
