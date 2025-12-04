import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';
import 'package:pocketbase/pocketbase.dart';

abstract interface class SeedRepository {
  factory SeedRepository() => const _FileSeedRepository();

  void write({
    required List<RecordModel> records,
    required String collectionName,
    required DirectoryPath dataDir,
  });

  List<RecordModel> read({
    required String collectionName,
    required DirectoryPath dataDir,
  });
}

final class _FileSeedRepository implements SeedRepository {
  const _FileSeedRepository();

  String fileForCollection(String collectionName) =>
      'pb_seed_$collectionName.json';

  @override
  void write({
    required List<RecordModel> records,
    required String collectionName,
    required DirectoryPath dataDir,
  }) {
    final filePath = dataDir.joinFile(fileForCollection(collectionName));
    final json = const JsonEncoder.withIndent('  ').convert(records);
    filePath.writeAsString(json);
  }

  @override
  List<RecordModel> read({
    required String collectionName,
    required DirectoryPath dataDir,
  }) {
    final filePath = dataDir.joinFile(fileForCollection(collectionName));
    if (filePath.notFound) {
      return [];
    }
    final json = filePath.readAsString();
    final List<dynamic> data = jsonDecode(json);

    return data
        .cast<Map<String, dynamic>>()
        .map(RecordModel.fromJson)
        .toList(growable: false);
  }
}
