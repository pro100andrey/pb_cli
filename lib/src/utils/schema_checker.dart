import 'dart:convert';

import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

/// Compares two lists of CollectionModel to check for schema changes.
///
/// It relies on collection name and content comparison.
bool checkPBSchema(
  List<CollectionModel> fromServer,
  List<CollectionModel> fromJsonFile,
  Logger logger,
) {
  if (fromServer.length != fromJsonFile.length) {
    logger.detail(
      'Difference found: Collection count mismatch '
      '(${fromServer.length} vs ${fromJsonFile.length})',
    );
    return false;
  }
  // Sort both lists by collection name to ensure reliable element-wise
  // comparison
  fromServer.sort((a, b) => a.name.compareTo(b.name));
  fromJsonFile.sort((a, b) => a.name.compareTo(b.name));

  for (var i = 0; i < fromServer.length; i++) {
    final existingCollection = fromServer[i];
    final incomingCollection = fromJsonFile[i];
    // Sanity check after sorting
    if (existingCollection.name != incomingCollection.name) {
      logger.detail(
        'Difference found: Collection name mismatch at '
        'index $i (${existingCollection.name} vs ${incomingCollection.name})',
      );
      return false;
    }

    // Compare collection content (rules, type, fields, etc.)
    if (!_isSameCollectionContent(
      existingCollection,
      incomingCollection,
      logger,
    )) {
      logger.detail(
        'Difference found in collection: ${existingCollection.name}',
      );
      return false;
    }
  }

  return true;
}

/// Compares two CollectionModel instances for content equality,
/// ignoring internal, volatile fields like 'id', 'created', and 'updated'.
bool _isSameCollectionContent(
  CollectionModel a,
  CollectionModel b,
  Logger logger,
) {
  // Create copies of the maps for normalization and comparison
  final aMap = a.toJson();
  final bMap = b.toJson();

  // Remove internal fields
  aMap
    ..remove('id')
    ..remove('created')
    ..remove('updated');

  bMap
    ..remove('id')
    ..remove('created')
    ..remove('updated');

  // Normalize fields for comparison (order might differ)
  final aFields = (aMap['fields'] as List<dynamic>?) ?? [];
  final bFields = (bMap['fields'] as List<dynamic>?) ?? [];

  if (aFields.length != bFields.length) {
    logger.detail('Field count mismatch');
    return false;
  }

  // Create maps of fields keyed by field name
  final aFieldsMap = {
    for (final f in aFields) (f as Map<String, dynamic>)['name']: f,
  };
  final bFieldsMap = {
    for (final f in bFields) (f as Map<String, dynamic>)['name']: f,
  };

  // Check if both collections have the exact same set of field names
  if (aFieldsMap.keys.toSet().difference(bFieldsMap.keys.toSet()).isNotEmpty) {
    logger.detail('Field names mismatch');
    return false;
  }

  // Remove the field lists from the main maps to compare them separately
  aMap.remove('fields');
  bMap.remove('fields');

  // Compare main collection properties (rules, type, etc.)
  if (jsonEncode(aMap) != jsonEncode(bMap)) {
    logger.detail('Collection properties mismatch (excluding fields)');
    return false;
  }

  // Compare each field individually
  for (final name in aFieldsMap.keys) {
    final fieldA = aFieldsMap[name]!;
    final fieldB = bFieldsMap[name]!;

    // Remove field IDs, as they are internal and volatile
    fieldA.remove('id');
    fieldB.remove('id');
    // Compare the rest of the field properties (type, required, options,
    // etc.)
    if (jsonEncode(fieldA) != jsonEncode(fieldB)) {
      logger.detail('Difference in field "$name" content');
      return false;
    }
  }

  return true;
}
