import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_state.freezed.dart';

@freezed
abstract class EnvState with _$EnvState {
  const factory EnvState({
    String? pbHost,
    String? pbUsername,
    String? pbPassword,
    String? pbToken,
  }) = _EnvState;
}
