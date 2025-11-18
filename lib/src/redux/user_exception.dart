class UserException implements Exception {
  const UserException(
    this.message, {
    this.code,
    this.reason,
  });

  /// Some message shown to the user.
  final String? message;

  final int? code;

  final String? reason;

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
          reason == other.reason;

  @override
  int get hashCode => message.hashCode ^ code.hashCode ^ reason.hashCode;
}
