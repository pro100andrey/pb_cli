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

  static String Function() defaultJoinString = () => "\n\n${"Reason:"} ";

  static String Function(String? first, String? second) joinCauses =
      (first, second) {
        if (first == null || first.isEmpty) {
          return second ?? '';
        }
        if (second == null || second.isEmpty) {
          return first;
        }
        return '$first${defaultJoinString()}$second';
      };

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
  String toString() => 'UserException';

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
