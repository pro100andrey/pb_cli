import 'dart:convert';

import '../models/credentials_source.dart';
import '../utils/path.dart';
import 'actions/action.dart';

/// Extension methods for convenient access to AppState properties.
extension type Selectors(AppState state) {
  DirectoryPath get workDir => state.workDir!;

  List<String> get managedCollections => state.config.managedCollections ?? [];

  CredentialsSource get credentialsSource =>
      state.config.credentialsSource ?? CredentialsSource.prompt;

  String? get pbHost => state.env.pbHost;

  String? get pbUsername => state.env.pbUsername;

  String? get pbPassword => state.env.pbPassword;

  String? get pbToken => state.env.pbToken;

  bool get tokenIsValid {
    final parts = pbToken?.split('.') ?? [];
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
}
