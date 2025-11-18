import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState({
    String? host,
    String? usernameOrEmail,
    String? password,
    String? token,
  }) = _SessionState;
}
