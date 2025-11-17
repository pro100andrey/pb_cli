import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.unresolved() = SessionUnresolved;

  const factory SessionState.token({
    required String host,
    required String token,
  }) = SessionToken;

  const factory SessionState.user({
    required String host,
    required String usernameOrEmail,
    required String password,
  }) = SessionUser;


}
