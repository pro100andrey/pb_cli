import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../utils/path.dart';

abstract interface class SeedRepository {
  void write(List<RecordModel> records, String collectionName);

  List<RecordModel> read(String collectionName);
}

final class FileSeedRepository implements SeedRepository {
  const FileSeedRepository(this._dataDir);

  final DirectoryPath _dataDir;

  String fileForCollection(String collectionName) =>
      'pb_seed_$collectionName.json';

  @override
  void write(List<RecordModel> records, String collectionName) {
    final filePath = _dataDir.joinFile(fileForCollection(collectionName));
    final json = const JsonEncoder.withIndent('  ').convert(records);
    filePath.writeAsString(json);
  }

  @override
  List<RecordModel> read(String collectionName) {
    final filePath = _dataDir.joinFile(fileForCollection(collectionName));
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
