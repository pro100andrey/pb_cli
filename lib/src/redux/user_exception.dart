class UserException implements Exception {
  const UserException(
    this.message, {
    this.code,
    this.reason,
    this.ifOpenDialog = true,
    this.errorText,
  });

  /// Creates a UserException instance from a JSON map.
  /// This is compatible with Serverpod.
  factory UserException.fromJson(Map<String, dynamic> json) => UserException(
    json['message'] as String?,
    code: json['code'] as int?,
    reason: json['reason'] as String?,
    ifOpenDialog: json['ifOpenDialog'] as bool? ?? true,
    errorText: json['errorText'] as String?,
  );

  /// Some message shown to the user.
  final String? message;

  final int? code;

  final String? reason;

  final bool ifOpenDialog;

  final String? errorText;

  UserException addReason(String? reason) {
    //
    if (reason == null) {
      return this;
    } else {
      if (_ifHasMsgOrCode()) {
        return UserException(
          message,
          code: code,
          reason: joinCauses(this.reason, reason),
          ifOpenDialog: ifOpenDialog,
          errorText: errorText,
        );
      } else if (this.reason != null && this.reason!.isNotEmpty) {
        return UserException(
          this.reason,
          reason: reason,
          ifOpenDialog: ifOpenDialog,
          errorText: errorText,
        );
      } else {
        return UserException(
          reason,
          ifOpenDialog: ifOpenDialog,
          errorText: errorText,
        );
      }
    }
  }

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

  UserException mergedWith(UserException? anotherUserException) {
    //
    if (anotherUserException == null) {
      return this;
    } else {
      final newReason = joinCauses(
        anotherUserException._msgOrCode(),
        anotherUserException.reason,
      );

      var mergedException = addReason(newReason);

      // If any of the exceptions has ifOpenDialog `false`, the merged
      // exception will have it too.
      if (ifOpenDialog && !anotherUserException.ifOpenDialog) {
        mergedException = mergedException.noDialog;
      }

      // If any of the exceptions has `errorText`, the merged exception will
      //have it too.
      // If both have it, keep the one from the [anotherUserException].
      if (anotherUserException.errorText?.isNotEmpty ?? false) {
        mergedException = mergedException.withErrorText(
          anotherUserException.errorText,
        );
      }

      return mergedException;
    }
  }

  /// This exception should NOT open a dialog.
  /// Still, the error may be shown in a different way, usually showing 
  /// [errorText] somewhere in the UI.
  /// This is the same as doing: `.withDialog(false)`.

  UserException get noDialog => withDialog(ifOpenDialog: false);

  /// Defines if this exception should open a dialog or not.
  /// If not, it will be shown in a different way, usually showing [errorText]
  /// somewhere in the UI.

  UserException withDialog({bool ifOpenDialog = true}) => UserException(
    message,
    reason: reason,
    code: code,
    ifOpenDialog: ifOpenDialog,
    errorText: errorText,
  );

  UserException withErrorText(String? newErrorText) => UserException(
    message,
    reason: reason,
    code: code,
    ifOpenDialog: ifOpenDialog,
    errorText: newErrorText,
  );

  (String, String) titleAndContent() {
    if (_ifHasMsgOrCode()) {
      if (reason == null || reason!.isEmpty) {
        return ('', _msgOrCode());
      } else {
        return (_msgOrCode(), reason ?? '');
      }
    }
    //
    else if (reason != null && reason!.isNotEmpty) {
      return ('', reason ?? '');
    }
    //
    else {
      return ('User Error', '');
    }
  }

  String _msgOrCode() {
    final code = this.code;
    if (code != null) {
      final codeAsText = 'Error code: $code';
      return codeAsText.isNotEmpty ? codeAsText : (message ?? '');
    } else {
      return message ?? '';
    }
  }

  bool _ifHasMsgOrCode() =>
      (message != null && message!.isNotEmpty) || code != null;

  /// Returns a new instance with some fields replaced by new values.
  /// This is compatible with Serverpod.
  UserException copyWith({
    String? message,
    int? code,
    String? reason,
    bool? ifOpenDialog,
    String? errorText,
  }) => UserException(
    message ?? this.message,
    code: code ?? this.code,
    reason: reason ?? this.reason,
    ifOpenDialog: ifOpenDialog ?? this.ifOpenDialog,
    errorText: errorText ?? this.errorText,
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
          reason == other.reason &&
          ifOpenDialog == other.ifOpenDialog &&
          errorText == other.errorText;

  @override
  int get hashCode =>
      message.hashCode ^
      code.hashCode ^
      reason.hashCode ^
      ifOpenDialog.hashCode ^
      errorText.hashCode;
}
