import 'package:cli_utils/cli_utils.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/enums/credentials_source.dart';
import '../types/session_token.dart';
import 'app_action.dart';

/// Extension type providing convenient read-only access to
/// [AppState] properties.
///
/// Selectors should:
/// - Only read state, never modify it
/// - Provide convenient computed properties
/// - Group related selectors together
/// - Use clear, descriptive names
///
/// Example:
/// ```dart
/// final selectors = Selectors(state);
/// if (selectors.hasToken && selectors.isTokenValid) {
///   print('User is authenticated with host: ${selectors.host}');
/// }
/// ```
extension type Selectors(AppState state) {
  // WorkDir selectors

  /// The current working directory path.
  ///
  /// Returns `null` if not yet resolved.
  DirectoryPath? get workDirPath => state.workDir.path;

  // Config selectors

  /// List of collection names that are managed by the CLI.
  ///
  /// Returns an empty list if no collections are configured.
  List<String> get managedCollections => state.config.data.managedCollections;

  /// The source for obtaining credentials (dotenv file or user prompt).
  ///
  /// Defaults to [CredentialsSource.prompt] if not explicitly configured.
  CredentialsSource get credentialsSource =>
      state.config.data.credentialsSource;

  // Session selectors

  /// JWT authentication token for the current session.
  ///
  /// Returns `null` if not authenticated.
  SessionToken? get token => state.session.token;

  /// PocketBase server URL (e.g., 'http://localhost:8090').
  ///
  /// Returns `null` if not configured.
  String? get host => state.session.host;

  /// Username or email used for authentication.
  ///
  /// Returns `null` if not set.
  String? get usernameOrEmail => state.session.usernameOrEmail;

  /// Password used for authentication.
  ///
  /// Returns `null` if not set. This value should be handled securely.
  String? get password => state.session.password;

  /// Whether a non-empty authentication token exists.
  bool get hasToken => token != null && token!.isNotEmpty;

  /// Whether the current token is valid (not expired).
  ///
  /// Returns `false` if no token exists or if it's expired.
  bool get isTokenValid => token != null && token!.isValid;

  // Schema selectors

  /// All collections in the PocketBase schema
  /// (including system collections).
  ///
  /// Returns an empty list if the schema hasn't been fetched yet.
  List<CollectionModel> get remoteCollections =>
      state.remoteSchema.collections ?? [];

  /// User-created collections (excludes system collections).
  Iterable<CollectionModel> get remoteCollectionsWithoutSystem =>
      remoteCollections.where((c) => !c.system);

  /// Names of user-created collections.
  ///
  /// Useful for displaying collection choices or filtering operations.
  Iterable<String> get remoteCollectionNamesWithoutSystem =>
      remoteCollectionsWithoutSystem.map((c) => c.name);
}
