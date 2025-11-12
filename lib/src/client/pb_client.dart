import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

import '../failure/failure.dart';
import '../models/result.dart';
import '../utils/console.dart';
import '../utils/strings.dart';

/// A wrapper around the [PocketBase] client providing simplified error handling
/// and CLI-specific functionality.
final class PbClient {
  const PbClient._({
    required PocketBase pb,
  }) : _pb = pb;

  final PocketBase _pb;

  /// The underlying [PocketBase] instance.
  PocketBase get instance => _pb;

  /// Authenticates as a superuser using the provided credentials.
  ///
  /// This method attempts to authenticate with PocketBase using the `
  /// _superusers` collection. Superuser authentication provides administrative
  /// access to the PocketBase instance.
  ///
  /// Returns a [CliResult] containing [RecordAuth] on success, or a [Failure]
  /// if authentication fails.
  ///
  /// Parameters:
  /// - [usernameOrEmail]: The superuser's username or email address
  /// - [password]: The superuser's password
  CliFuture<RecordAuth> _logInAsSuperuser({
    required String usernameOrEmail,
    required String password,
  }) async => _op(
    () async => _pb
        .collection('_superusers')
        .authWithPassword(usernameOrEmail, password),
  );

  /// Fetches all collections from the PocketBase instance.
  ///
  /// Returns a [CliFuture] that completes with a list of [CollectionModel] on
  /// success.
  CliFuture<List<CollectionModel>> getCollections() async =>
      _op(() async => _pb.collections.getFullList());

  /// Imports collections into the PocketBase instance.
  ///
  /// - [collections]: A list of [CollectionModel] to import.
  /// - [deleteMissing]: If `true`, collections that exist in the PocketBase
  ///   instance but not in the provided list will be deleted.
  CliFuture<void> importCollections(
    List<CollectionModel> collections, {
    bool deleteMissing = false,
  }) async => _op(
    () async => _pb.collections.import(
      collections,
      deleteMissing: deleteMissing,
    ),
  );

  Uri fileUri({required RecordModel record, required String fileName}) {
    final url = _pb.files.getURL(record, fileName);

    return url;
  }

  /// Deletes all records in a specific collection.
  ///
  /// - [collectionName]: The name of the collection to truncate.
  CliFuture<void> truncateCollection(
    String collectionName,
  ) async => _op(() async => _pb.collections.truncate(collectionName));

  /// Checks if a collection is empty.
  ///
  /// - [collectionName]: The name of the collection to check.
  ///
  /// Returns a [CliFuture] that completes with `true` if the collection has no
  /// records, and `false` otherwise.
  CliFuture<bool> collectionIsEmpty(
    String collectionName,
  ) async => _op(() async {
    final existingItems = await _pb
        .collection(collectionName)
        .getList(perPage: 1, skipTotal: true);

    return existingItems.items.isEmpty;
  });

  CliFuture<ResultList<RecordModel>> getCollectionRecordsBatch(
    String collectionName,
    int batchSize,
    int offset,
  ) async => _op(() async {
    final result = await _pb
        .collection(collectionName)
        .getList(perPage: batchSize, page: (offset ~/ batchSize) + 1);

    return result;
  });

  /// Executes a PocketBase operation and wraps it in a [CliResult].
  ///
  /// This method centralizes error handling for PocketBase API calls.
  /// It catches [ClientException] and other potential errors, converting them
  /// into a [Failure] object.
  ///
  /// - [operation]: The asynchronous PocketBase operation to execute.
  ///
  /// Returns a [CliResult] containing the operation's result on success,
  /// or a [Failure] on error.
  CliFuture<T> _op<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return result.asResult();
    } on ClientException catch (e) {
      final originalError = e.originalError;

      final message = switch (e) {
        ClientException(response: {'message': final String message}) =>
          '(${e.statusCode}) $message',

        ClientException(originalError: Exception())
            when originalError != null =>
          '$originalError',

        _ => 'Unexpected error',
      };

      final failure = Failure.fromHttpStatus(
        e.statusCode,
        message: message,
        details: e.url,
      );

      return failure.asResult();
    } on Object catch (e) {
      return Failure.software(message: 'Unexpected error: $e').asResult();
    }
  }
}

/// Resolves a [PbClient] instance.
///
/// This function creates and authenticates a PocketBase client.
/// If a valid [token] is provided, it will be used for authentication.
/// Otherwise, it will attempt to log in as a superuser with the provided
/// [usernameOrEmail] and [password].
///
/// It displays progress and status messages using the provided [logger].
///
/// Returns a [CliResult] containing the authenticated [PbClient] on success,
/// or a [Failure] if the connection or authentication fails.
CliFuture<PbClient> resolvePbClient({
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
    loginProgress.fail(
      Console.error(
        S.pocketBaseFailed(error.message),
        context: error.details?.toString(),
        suggestion: 'Check your credentials and try again.',
      ),
    );
    return error.asResult();
  }

  loginProgress.complete('Connected and authenticated successfully.');

  return pbClient.asResult();
}
