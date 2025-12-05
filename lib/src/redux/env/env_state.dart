import 'package:freezed_annotation/freezed_annotation.dart';

import '../types/env.dart';

part 'env_state.freezed.dart';

/// State representing raw data loaded from .env file.
/// This is the source of truth for what exists in the .env file.
@freezed
abstract class EnvState with _$EnvState {
  const factory EnvState({
    /// Raw key-value pairs from .env file.
    @Default(EnvData.empty()) EnvData data,
  }) = _EnvState;

  const EnvState._();
}
