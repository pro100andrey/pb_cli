import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../models/credentials_source.dart';
import '../utils/path.dart';
import 'actions/action.dart';
import 'session/session_state.dart';

/// Extension methods for convenient access to AppState properties.
extension type Selectors(AppState state) {
  DirectoryPath get workDir => state.workDir!;

  List<String> get managedCollections => state.config.managedCollections ?? [];

  CredentialsSource get credentialsSource =>
      state.config.credentialsSource ?? CredentialsSource.prompt;

  SessionState get session => state.session;

  String? get token => state.env.token;

  bool get hasToken => token != null && token!.isNotEmpty;

  bool get tokenIsValid {
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

  List<CollectionModel> get collections => state.schema.collections ?? [];

  Iterable<CollectionModel> get collectionsWithoutSystem =>
      collections.where((c) => !c.system);

  Iterable<String> get collectionNamesWithoutSystem =>
      collectionsWithoutSystem.map((c) => c.name);
}
