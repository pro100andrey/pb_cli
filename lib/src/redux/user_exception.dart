class UserException implements Exception {
  /// Creates a new [UserException].
  ///
  /// [message] is the message shown to the user.
  /// [code] is an optional error code.
  /// [reason] is an optional reason for the error (e.g. for debugging).
  /// [exitCode] is an optional exit code (e.g. for CLI apps).
  const UserException(
    this.message, {
    this.code,
    this.reason,
    this.exitCode,
  });

  /// Some message shown to the user.
  final String? message;

  /// An optional error code.
  final int? code;

  /// An optional reason for the error (e.g. for debugging).
  final String? reason;

  /// An optional exit code (e.g. for CLI apps).
  final int? exitCode;

  /// Returns a new instance with some fields replaced by new values.
  /// This is compatible with Serverpod.
  UserException copyWith({
    String? message,
    int? code,
    String? reason,
  }) => UserException(
    message ?? this.message,
    code: code ?? this.code,
    reason: reason ?? this.reason,
  );

  @override
  String toString() {
    final fields = {
      'message': ?message,
      'code': ?code,
      'exitCode': ?exitCode,
      'reason': ?reason,
    }.entries.map((e) => ' - ${e.key}: ${e.value}');

    return 'UserException\n${fields.join('\n')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code &&
          reason == other.reason &&
          exitCode == other.exitCode;

  @override
  int get hashCode =>
      message.hashCode ^ code.hashCode ^ reason.hashCode ^ exitCode.hashCode;
}
