import '../../common.dart';

final class ValidateCredentialsAction extends AppAction {
  @override
  AppState? reduce() {
    final missingFields = <String>[];

    if (select.host == null || select.host!.isEmpty) {
      missingFields.add('host');
    }

    if (select.usernameOrEmail == null || select.usernameOrEmail!.isEmpty) {
      missingFields.add('username/email');
    }

    if (select.password == null || select.password!.isEmpty) {
      missingFields.add('password');
    }

    if (missingFields.isNotEmpty) {
      throw ValidationException(
        'Missing required credentials: ${missingFields.join(", ")}',
      );
    }

    logger.detail('All credentials are present');
    return null;
  }
}
