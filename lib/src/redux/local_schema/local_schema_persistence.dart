import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

/// Reads local schema from a JSON file.

IList<CollectionModel> readLocalSchema({required FilePath inputFile}) {
  if (inputFile.notFound) {
    return const IListConst([]);
  }

  final contents = inputFile.readAsString();
  final schemaData = jsonDecode(contents) as List;

  return schemaData
      .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
      .toIList();
}

/// Writes local schema to a JSON file.
void writeLocalSchema({
  required FilePath outputFile,
  required IList<CollectionModel> collections,
}) {
  final view = collections.unlockView;
  final json = const JsonEncoder.withIndent('\t').convert(view);

  outputFile.writeAsString(json);
}
