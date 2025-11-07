import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';

import '../utils/path.dart';

/// Abstract interface for schema repository operations.
///
/// This interface defines the contract for reading and writing PocketBase
/// schema definitions. Implementations should handle the persistence and
/// retrieval of collection schemas in their respective storage mechanisms.
///
/// The schema typically includes:
/// - Collection definitions with fields, types, and validation rules
/// - Index configurations
/// - Collection-level settings and permissions
/// - Field-specific options and constraints
abstract interface class SchemaRepository {
  /// Writes the schema definitions to storage.
  ///
  /// [collections] The list of collection models to persist. Each collection
  /// contains its complete schema definition including fields, rules, and
  /// configuration.
  ///
  /// This method should serialize the collection models and store them in a
  /// format that can be later retrieved by [readSchema].
  ///
  /// Example:
  /// ```dart
  /// final collections = [
  ///   CollectionModel(name: 'users', fields: [...]),
  ///   CollectionModel(name: 'posts', fields: [...]),
  /// ];
  /// schemaRepository.writeSchema(collections);
  /// ```
  ///
  /// Throws an exception if the schema cannot be written to storage.
  void writeSchema(List<CollectionModel> collections);

  /// Reads the schema definitions from storage.
  ///
  /// Returns a list of [CollectionModel] instances representing the stored
  /// schema definitions. If no schema exists, implementations should return
  /// an empty list.
  ///
  /// Example:
  /// ```dart
  /// final collections = schemaRepository.readSchema();
  /// for (final collection in collections) {
  ///   print('Collection: ${collection.name}');
  /// }
  /// ```
  ///
  /// Throws an exception if the schema cannot be read or parsed.
  List<CollectionModel> readSchema();
}

/// File-based implementation of schema repository.
///
/// This class manages PocketBase schema definitions by storing them as JSON
/// files in a specified data directory. The schema is serialized to a single
/// JSON file containing all collection definitions.
///
/// The JSON format preserves all collection metadata including:
/// - Field definitions with types and constraints
/// - Collection rules and permissions
/// - Indexes and relationships
/// - Custom validation logic
///
/// Example usage:
/// ```dart
/// final dataDir = DirectoryPath('./pb_data');
/// final schemaRepo = FileSchemaRepository(dataDir);
///
/// // Write schema
/// final collections = await pbClient.getCollections();
/// schemaRepo.writeSchema(collections);
///
/// // Read schema later
/// final storedCollections = schemaRepo.readSchema();
/// ```
final class FileSchemaRepository implements SchemaRepository {
  /// Creates a new file-based schema repository.
  ///
  /// [_dataDir] The directory where schema files will be stored.
  const FileSchemaRepository(this._dataDir);

  /// The data directory where schema files are stored.
  final DirectoryPath _dataDir;

  /// The filename used for storing schema definitions.
  static const file = 'pb_schema.json';

  /// Gets the path to the schema file.
  FilePath get _schemaFile => _dataDir.joinFile(file);

  @override
  void writeSchema(List<CollectionModel> collections) {
    final json = const JsonEncoder.withIndent('  ').convert(collections);
    _schemaFile.writeAsString(json);
  }

  @override
  List<CollectionModel> readSchema() {
    if (_schemaFile.notFound) {
      return [];
    }

    final jsonString = _schemaFile.readAsString();

    if (jsonDecode(jsonString) case final List list) {
      final collections = list
          .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return collections;
    }

    throw const FormatException('Invalid schema file format');
  }
}
