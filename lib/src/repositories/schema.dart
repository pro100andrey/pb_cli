import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../utils/path.dart';

abstract interface class SchemaRepository {
  void writeSchema(List<CollectionModel> collections);

  List<CollectionModel> readSchema();
}

final class FileSchemaRepository implements SchemaRepository {
  const FileSchemaRepository(this._dataDir);

  final DirectoryPath _dataDir;

  static const file = 'pb_schema.json';

  FilePath get _schemaFile => _dataDir.joinFile(file);

  @override
  void writeSchema(List<CollectionModel> collections) {
    final json = const JsonEncoder.withIndent('  ').convert(collections);
    _schemaFile.writeAsString(json);
  }

  @override
  List<CollectionModel> readSchema() => [];
}
