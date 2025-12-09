import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../common.dart';

final class CompareSchemasAction extends AppAction {
  @override
  AppState? reduce() {
    final local = select.localCollections;
    final remote = select.remoteCollections;

    final isSame = compareSchemas(local: local, remote: remote);

    logger.info(
      !isSame
          ? 'Local schema differs from remote PocketBase schema.'
          : 'Local schema is the same as remote PocketBase schema.',
    );

    return null;
  }

  /// Compares local and remote collection schemas for equality.
  ///
  /// Returns `true` if schemas are identical (ignoring internal fields),
  /// `false` otherwise. Logs detailed differences when found.
  ///
  /// Parameters:
  /// - [local]: Local collection schema
  /// - [remote]: Remote collection schema from PocketBase
  bool compareSchemas({
    required IList<CollectionModel> local,
    required IList<CollectionModel> remote,
  }) {
    if (remote.length != local.length) {
      logger.detail(
        'Difference found: Collection count mismatch '
        '(${remote.length} vs ${local.length})',
      );

      return false;
    }

    // Sort both lists by collection name to ensure reliable element-wise
    // comparison
    final remoteSorted = remote.sort((a, b) => a.name.compareTo(b.name));
    final localSorted = local.sort((a, b) => a.name.compareTo(b.name));

    for (var i = 0; i < remoteSorted.length; i++) {
      final remoteCollection = remoteSorted[i];
      final localCollection = localSorted[i];
      // Sanity check after sorting
      if (remoteCollection.name != localCollection.name) {
        logger.detail(
          'Difference found: Collection name mismatch at '
          'index $i (${remoteCollection.name} vs ${localCollection.name})',
        );
        return false;
      }

      // Compare collection content (rules, type, fields, etc.)
      if (!_collectionsHaveSameContent(
        remoteCollection,
        localCollection,
      )) {
        logger.detail(
          'Difference found in collection: ${remoteCollection.name}',
        );
        return false;
      }
    }

    return true;
  }

  bool _collectionsHaveSameContent(
    CollectionModel remoteCollection,
    CollectionModel localCollection,
  ) {
    // Create copies of the maps for normalization and comparison
    final remoteMap = remoteCollection.toJson();
    final localMap = localCollection.toJson();

    // Remove internal fields
    remoteMap
      ..remove('id')
      ..remove('created')
      ..remove('updated');

    localMap
      ..remove('id')
      ..remove('created')
      ..remove('updated');

    _normalizeRuleFields(remoteMap);
    _normalizeRuleFields(localMap);

    _normalizeIndexes(remoteMap);
    _normalizeIndexes(localMap);

    // Normalize fields for comparison (order might differ)
    final remoteFields = (remoteMap['fields'] as List<dynamic>?) ?? [];
    final localFields = (localMap['fields'] as List<dynamic>?) ?? [];

    final remoteFieldsMap = {
      for (final f in remoteFields) (f as Map<String, dynamic>)['name']: f,
    };

    final localFieldsMap = {
      for (final f in localFields) (f as Map<String, dynamic>)['name']: f,
    };

    final remoteFieldNames = remoteFieldsMap.keys.toSet();
    final localFieldNames = localFieldsMap.keys.toSet();

    final fieldsMissingOnServer = localFieldNames.difference(remoteFieldNames);
    final fieldsMissingInFile = remoteFieldNames.difference(localFieldNames);
    if (remoteFieldNames.length != localFieldNames.length ||
        fieldsMissingOnServer.isNotEmpty ||
        fieldsMissingInFile.isNotEmpty) {
      logger.detail('Difference found in ${remoteCollection.name} fields:');

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
    remoteMap.remove('fields');
    localMap.remove('fields');

    // Compare main collection properties (rules, type, etc.)
    if (jsonEncode(remoteMap) != jsonEncode(localMap)) {
      logger.detail('Collection properties mismatch (excluding fields)');
      return false;
    }

    // Compare each field individually
    for (final name in remoteFieldsMap.keys) {
      final remoteField = remoteFieldsMap[name]!;
      final localField = localFieldsMap[name]!;

      // Remove field IDs, as they are internal and volatile
      remoteField.remove('id');
      localField.remove('id');
      // Compare the rest of the field properties (type, required, options,
      // etc.)
      if (jsonEncode(remoteField) != jsonEncode(localField)) {
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
