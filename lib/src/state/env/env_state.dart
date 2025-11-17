import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_state.freezed.dart';

@freezed
abstract class EnvState with _$EnvState {
  const factory EnvState({
    String? host,
    String? usernameOrEmail,
    String? password,
    String? token,
  }) = _EnvState;
}
