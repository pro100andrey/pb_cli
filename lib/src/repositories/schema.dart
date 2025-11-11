import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../utils/path.dart';

abstract interface class SchemaRepository {
  factory SchemaRepository() => const _FileSchemaRepository();

  List<CollectionModel> read({required DirectoryPath dataDir});

  void write({
    required List<CollectionModel> collections,
    required DirectoryPath dataDir,
  });
}

final class _FileSchemaRepository implements SchemaRepository {
  const _FileSchemaRepository();

  static const file = 'pb_schema.json';

  FilePath _file(DirectoryPath dataDir) => dataDir.joinFile(file);

  @override
  void write({
    required List<CollectionModel> collections,
    required DirectoryPath dataDir,
  }) {
    final file = _file(dataDir);
    final json = const JsonEncoder.withIndent('  ').convert(collections);
    file.writeAsString(json);
  }

  @override
  List<CollectionModel> read({required DirectoryPath dataDir}) {
    final file = _file(dataDir);

    if (file.notFound) {
      return [];
    }

    final jsonString = file.readAsString();

    if (jsonDecode(jsonString) case final List list) {
      final collections = list
          .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return collections;
    }

    throw const FormatException('Invalid schema file format');
  }
}
