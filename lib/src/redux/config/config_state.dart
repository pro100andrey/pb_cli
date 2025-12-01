import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/credentials_source.dart';

part 'config_state.freezed.dart';

@freezed
abstract class ConfigState with _$ConfigState {
  const factory ConfigState({
    List<String>? managedCollections,
    CredentialsSource? credentialsSource,
  }) = _ConfigState;
}
