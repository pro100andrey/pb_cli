import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../models/credentials_source.dart';
import '../utils/path.dart';
import 'action.dart';

/// Extension methods for convenient access to AppState properties.
extension type Selectors(AppState state) {
  // WorkDir selectors

  /// Working directory path
  DirectoryPath? get workDirPath => state.workDir.path;

  /// Indicates whether to create the working directory if it does not exist
  bool get shouldCreateWorkDir =>
      state.workDir.resolveOption == .createIfNotExists;

  // Config selectors

  /// Selected managed collections from the config.
  /// Defaults to an empty list if none are set.
  List<String> get managedCollections => state.config.managedCollections ?? [];

  /// Selected credentials source from the config.
  /// Defaults to [CredentialsSource.prompt] if none is set.
  CredentialsSource get credentialsSource =>
      state.config.credentialsSource ?? CredentialsSource.prompt;

  /// Session selectors

  /// PocketBase authentication token
  String? get token => state.session.token;

  /// PocketBase connection host
  String? get host => state.session.host;

  /// Username or email used for authentication
  String? get usernameOrEmail => state.session.usernameOrEmail;

  /// Password used for authentication
  String? get password => state.session.password;

  /// Checks if a valid authentication token is present
  bool get hasToken => token != null && token!.isNotEmpty;

  /// Checks if the current token is valid based on its expiration time.
  bool get isTokenValid {
    final parts = token?.split('.') ?? [];
    if (parts.length != 3) {
      return false;
    }

    final tokenPart = base64.normalize(parts[1]);
    final rawDataPart = base64Decode(tokenPart);
    final dataPart = utf8.decode(rawDataPart);
    final data = jsonDecode(dataPart) as Map<String, dynamic>;

    final exp = data['exp'] is int
        ? data['exp'] as int
        : (int.tryParse(data['exp'].toString()) ?? 0);

    return exp > (DateTime.now().millisecondsSinceEpoch / 1000);
  }

  // Schema selectors

  List<CollectionModel> get collections => state.schema.collections ?? [];

  Iterable<CollectionModel> get collectionsWithoutSystem =>
      collections.where((c) => !c.system);

  Iterable<String> get collectionNamesWithoutSystem =>
      collectionsWithoutSystem.map((c) => c.name);
}
