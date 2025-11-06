import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../failure/failure.dart';
import '../models/result.dart';

Future<CliResult<PbClient>> resolvePbClient({
  required String host,
  required String usernameOrEmail,
  required String password,
  required Logger logger,
  String? token,
}) async {
  final auth = AuthStore();

  if (token != null && token.isNotEmpty) {
    auth.save(token, null);
  }

  final pb = PocketBase(host, authStore: auth);
  final pbClient = PbClient._(pb: pb);

  // Return existing authenticated client
  if (auth.token.isNotEmpty && auth.isValid) {
    logger.info('Using existing authentication token.');
    return pbClient.asResult();
  }

  final loginProgress = logger.progress(
    'Connecting to PocketBase at $host...',
  );

  // If no valid token is available, log in as superuser
  final authResult = await pbClient._logInAsSuperuser(
    usernameOrEmail: usernameOrEmail,
    password: password,
  );

  if (authResult case Result(:final error?)) {
    loginProgress.fail('Authentication failed: ${error.message}');
    return error.asResult();
  }

  loginProgress.complete('Connected and authenticated successfully.');

  return pbClient.asResult();
}

final class PbClient {
  const PbClient._({
    required PocketBase pb,
  }) : _pb = pb;

  final PocketBase _pb;

  PocketBase get instance => _pb;

  Future<CliResult<RecordAuth>> _logInAsSuperuser({
    required String usernameOrEmail,
    required String password,
  }) async => _op(
    () async => _pb
        .collection('_superusers')
        .authWithPassword(
          usernameOrEmail,
          password,
        ),
  );

  CliFuture<List<CollectionModel>> getCollections() async =>
      _op(() async => _pb.collections.getFullList());

  CliFuture<void> importCollections(
    List<CollectionModel> collections, {
    bool deleteMissing = false,
  }) async => _op(
    () async => _pb.collections.import(
      collections,
      deleteMissing: deleteMissing,
    ),
  );

  CliFuture<void> truncateCollection(
    String collectionName,
  ) async => _op(() async => _pb.collections.truncate(collectionName));

  CliFuture<bool> collectionIsEmpty(
    String collectionName,
  ) async => _op(() async {
    final existingItems = await _pb
        .collection(collectionName)
        .getList(perPage: 1, skipTotal: true);

    return existingItems.items.isEmpty;
  });

  /// Executes an operation and handles common PocketBase errors.
  Future<CliResult<T>> _op<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return result.asResult();
    } on ClientException catch (e) {
      final originalError = e.originalError;

      final message = switch (e) {
        ClientException(response: {'message': final String message}) =>
          '${e.statusCode} - $message',

        ClientException(originalError: Exception())
            when originalError != null =>
          '$originalError',

        _ => 'Unexpected error',
      };

      final failure = Failure.fromHttpStatus(
        e.statusCode,
        message: message,
      );

      return failure.asResult();
    } on Object catch (e) {
      return Failure.software(message: 'Unexpected error: $e').asResult();
    }
  }
}
