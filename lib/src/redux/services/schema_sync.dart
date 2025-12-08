import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pocketbase/pocketbase.dart';

class SchemaSyncService {
  const SchemaSyncService({required Logger logger}) : _logger = logger;

  final Logger _logger;

  bool syncSchema({
    required IList<CollectionModel> localCollections,
    required IList<CollectionModel> remoteCollections,
  }) {
    // Create mutable copies of the collections lists to avoid modifying
    // the original data
    final sCollections = remoteCollections.unlockLazy;
    final lCollections = localCollections.unlockLazy;

    final isSame = _checkPBSchema(sCollections, lCollections, _logger);

    return isSame;
  }

  bool _checkPBSchema(
    List<CollectionModel> sCollections,
    List<CollectionModel> lCollections,
    Logger logger,
  ) {
    if (sCollections.length != lCollections.length) {
      logger.detail(
        'Difference found: Collection count mismatch '
        '(${sCollections.length} vs ${lCollections.length})',
      );

      return false;
    }

    // Sort both lists by collection name to ensure reliable element-wise
    // comparison
    sCollections.sort((a, b) => a.name.compareTo(b.name));
    lCollections.sort((a, b) => a.name.compareTo(b.name));

    for (var i = 0; i < sCollections.length; i++) {
      final sCollection = sCollections[i];
      final lCollection = lCollections[i];
      // Sanity check after sorting
      if (sCollection.name != lCollection.name) {
        logger.detail(
          'Difference found: Collection name mismatch at '
          'index $i (${sCollection.name} vs ${lCollection.name})',
        );
        return false;
      }

      // Compare collection content (rules, type, fields, etc.)
      if (!_isSameCollectionContent(sCollection, lCollection, logger)) {
        logger.detail('Difference found in collection: ${sCollection.name}');
        return false;
      }
    }

    return true;
  }

  bool _isSameCollectionContent(
    CollectionModel sCollection,
    CollectionModel lCollection,
    Logger logger,
  ) {
    // Create copies of the maps for normalization and comparison
    final sMap = sCollection.toJson();
    final lMap = lCollection.toJson();

    // Remove internal fields
    sMap
      ..remove('id')
      ..remove('created')
      ..remove('updated');

    lMap
      ..remove('id')
      ..remove('created')
      ..remove('updated');

    _normalizeRuleFields(sMap);
    _normalizeRuleFields(lMap);

    _normalizeIndexes(sMap);
    _normalizeIndexes(lMap);

    // Normalize fields for comparison (order might differ)
    final sFields = (sMap['fields'] as List<dynamic>?) ?? [];
    final lFields = (lMap['fields'] as List<dynamic>?) ?? [];

    final sFieldsMap = {
      for (final f in sFields) (f as Map<String, dynamic>)['name']: f,
    };

    final lFieldsMap = {
      for (final f in lFields) (f as Map<String, dynamic>)['name']: f,
    };

    final sFieldNames = sFieldsMap.keys.toSet();
    final lFieldNames = lFieldsMap.keys.toSet();

    final fieldsMissingOnServer = lFieldNames.difference(sFieldNames);
    final fieldsMissingInFile = sFieldNames.difference(lFieldNames);
    if (sFieldNames.length != lFieldNames.length ||
        fieldsMissingOnServer.isNotEmpty ||
        fieldsMissingInFile.isNotEmpty) {
      logger.detail('Difference found in ${sCollection.name} fields:');

      if (fieldsMissingInFile.isNotEmpty) {
        logger.detail(
          ' > Fields missing in File (added on server): '
          '${fieldsMissingInFile.join(', ')}',
        );
      }

      if (fieldsMissingOnServer.isNotEmpty) {
        logger.detail(
          ' > Fields missing on Server (removed on server): '
          '${fieldsMissingOnServer.join(', ')}',
        );
      }

      return false;
    }

    // Remove the field lists from the main maps to compare them separately
    sMap.remove('fields');
    lMap.remove('fields');

    // Compare main collection properties (rules, type, etc.)
    if (jsonEncode(sMap) != jsonEncode(lMap)) {
      logger.detail('Collection properties mismatch (excluding fields)');
      return false;
    }

    // Compare each field individually
    for (final name in sFieldsMap.keys) {
      final fieldA = sFieldsMap[name]!;
      final fieldB = lFieldsMap[name]!;

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

  void _normalizeRuleFields(Map<String, dynamic> map) {
    const ruleFields = [
      'listRule',
      'viewRule',
      'createRule',
      'updateRule',
      'deleteRule',
      'authRule',
      'manageRule',
    ];
    for (final field in ruleFields) {
      // Treat null or empty string as "no rule"
      if (map[field] == null || map[field] == '') {
        map.remove(field);
      }
    }
  }

  void _normalizeIndexes(Map<String, dynamic> map) {
    final indexes = (map['indexes'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();

    if (indexes != null && indexes.isNotEmpty) {
      indexes.sort();
      map['indexes'] = indexes;
    } else {
      // Remove if empty or null to ensure consistent comparison
      map.remove('indexes');
    }
  }
}
